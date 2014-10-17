require 'api_auth'

class Syncinator
  include Mongoid::Document

  FIXNUM_MAX = (2**(0.size * 8 -2) -1)

  field :name, type: String
  field :slug, type: String
  field :access_id, type: Integer
  field :secret_key, type: String
  field :queue_changes, type: Boolean
  field :active, type: Boolean, default: true

  attr_readonly :slug, :access_id, :secret_key

  validates :name, :slug, :access_id, :secret_key, presence: true
  validates :name, :slug, :access_id, :secret_key, uniqueness: true

  before_validation :set_default_slug, :set_access_id, :set_secret_key, on: :create

  def to_s
    name
  end

  def unfinished_changesets
    Changeset.where(
      :change_syncs.elem_match => {syncinator_id: id, :run_after.ne => nil}
    ).order_by(created_at: :asc)
  end

  def startable_changesets
    Changeset.where(
      :change_syncs.elem_match => {syncinator_id: id, :run_after.lt => Time.now }
    ).order_by(created_at: :asc)
  end

  def start!(changeset)
    return false unless change_sync = change_sync_for(changeset)

    change_sync.sync_logs.create! started_at: Time.now
  end

  def error!(sync_log, message)
    sync_log.update_attributes errored_at: Time.now, message: message
    sync_log
  end

  def finish!(sync_log, action, message = nil)
    sync_log.update_attributes succeeded_at: Time.now, action: action, message: message
    sync_log
  end

  private

  def change_sync_for(changeset)
    changeset.change_syncs.find_by(syncinator: self)
  end

  def set_default_slug
    self.slug ||= name.parameterize
  end

  def set_access_id
    self.access_id ||= rand(FIXNUM_MAX)
  end

  def set_secret_key
    self.secret_key ||= ApiAuth.generate_secret_key
  end
end

require 'api_auth'

class Syncinator
  include Mongoid::Document
  include Mongoid::Userstamp::User

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

  def changesets
    Changeset.where('change_syncs.syncinator_id' => id).order_by(created_at: :asc)
  end

  def unfinished_changesets
    Changeset.where(
      :change_syncs.elem_match => {syncinator_id: id, :run_after.ne => nil}
    ).order_by(created_at: :asc)
  end

  # have started but haven't errored or succeeded
  def pending_changesets
    Changeset.where(
      :change_syncs.elem_match => {
        syncinator_id: id, :run_after.ne => nil, :sync_logs.elem_match => {
          :started_at.ne => nil, errored_at: nil, succeeded_at: nil
        }
      }
    ).order_by(created_at: :asc)
  end

  def errored_changesets
    Changeset.where(
      :change_syncs.elem_match => {
        syncinator_id: id, :run_after.ne => nil, :'sync_logs.errored_at'.exists => true
      }
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
    sync_log.errored_at = Time.now
    sync_log.message = message
    sync_log.save!

    sync_log
  end

  def finish!(sync_log, action, message = nil)
    sync_log.succeeded_at = Time.now
    sync_log.action = action
    sync_log.message = message
    sync_log.save!

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

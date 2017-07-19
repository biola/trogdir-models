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
  field :errored_count, type: Integer, default: 0
  field :pending_count, type: Integer, default: 0
  field :unfinished_count, type: Integer, default: 0

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

    # delete old pending sync_logs before creating a new one
    change_sync.sync_logs.where(succeeded_at: nil, errored_at: nil).delete

    change_sync.sync_logs.create! started_at: Time.now
  end

  def error!(sync_log, message)
    # Because we have to save the change_sync instead of the sync_log (see below)
    # we need to make sure we grab the sync_log through the change_sync, other wise
    # the save on change_sync doesn't catch the changes to sync_log.
    change_sync = sync_log.change_sync
    sync_log = change_sync.sync_logs.find_by(id: sync_log.id)

    sync_log.errored_at = Time.now
    sync_log.message = message
    # There seems to be a bug in mongoid 4.0.2 that saves two records if you call just
    # sync_log.save!. Calling save on the ChangeSync seems to be the best work-around for now.
    # Thanks to Michael for finding the least-stupid workaround.
    # TODO: do a simple sync_log.save! when this issue gets fixed.
    sync_log.change_sync.save!

    sync_log
  end

  def finish!(sync_log, action, message = nil)
    # Because we have to save the change_sync instead of the sync_log (see below)
    # we need to make sure we grab the sync_log through the change_sync, other wise
    # the save on change_sync doesn't catch the changes to sync_log.
    change_sync = sync_log.change_sync
    sync_log = change_sync.sync_logs.find_by(id: sync_log.id)

    sync_log.succeeded_at = Time.now
    sync_log.action = action
    sync_log.message = message
    # There seems to be a bug in mongoid 4.0.2 that saves two records if you call just
    # sync_log.save!. Calling save on the ChangeSync seems to be the best work-around for now.
    # Thanks to Michael for finding the least-stupid workaround.
    # TODO: do a simple sync_log.save! when this issue gets fixed.
    sync_log.change_sync.save!

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

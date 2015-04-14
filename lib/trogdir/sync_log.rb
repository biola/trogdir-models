class SyncLog
  include Mongoid::Document

  embedded_in :change_sync

  field :started_at, type: Time
  field :errored_at, type: Time
  field :succeeded_at, type: Time
  field :action, type: Symbol
  field :message, type: String

  validates :started_at, presence: true

  before_save :update_change_sync
  after_save :save_change_sync

  delegate :changeset, :syncinator, to: :change_sync

  def self.find_through_parents(id)
    id = BSON::ObjectId.from_string(id.to_s) unless id.is_a? BSON::ObjectId
    changeset = Changeset.find_by('change_syncs.sync_logs._id' => id)
    change_sync = changeset.change_syncs.find_by('sync_logs._id' => id)
    change_sync.sync_logs.find(id)
  end

  private

  def update_change_sync
    change_sync.update_run_after
  end

  def save_change_sync
    change_sync.save! if change_sync.run_after_changed?
  end
end

class SyncLog
  include Mongoid::Document

  embedded_in :change_sync

  field :started_at, type: Time
  field :errored_at, type: Time
  field :succeeded_at, type: Time
  field :action, type: Symbol
  field :message, type: String

  validates :started_at, presence: true

  delegate :changeset, to: :change_sync

  def self.find_through_parents(id)
    id = Moped::BSON::ObjectId(id)
    changeset = Changeset.find_by('change_syncs.sync_logs._id' => id)
    change_sync = changeset.change_syncs.find_by('sync_logs._id' => id)
    change_sync.sync_logs.find(id)
  end
end

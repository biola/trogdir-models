class SyncLog
  include Mongoid::Document

  embedded_in :change_sync

  field :started_at, type: Time
  field :errored_at, type: Time
  field :succeeded_at, type: Time
  field :action, type: Symbol
  field :message, type: String

  validates :started_at, presence: true
end
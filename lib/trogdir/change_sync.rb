class ChangeSync
  include Mongoid::Document

  embedded_in :changeset
  belongs_to :syncinator
  embeds_many :sync_logs
  field :run_after, type: Time, default: -> { Time.now - 1 }
end

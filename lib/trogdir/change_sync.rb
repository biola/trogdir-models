class ChangeSync
  include Mongoid::Document

  embedded_in :changeset
  belongs_to :syncinator
  embeds_many :sync_logs
end
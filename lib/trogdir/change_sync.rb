class ChangeSync
  include Mongoid::Document

  belongs_to :changeset
  belongs_to :syncinator
  embeds_many :sync_logs
end
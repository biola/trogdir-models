class ChangeSync
  include Mongoid::Document

  belongs_to :changeset
  belongs_to :syncinator
end
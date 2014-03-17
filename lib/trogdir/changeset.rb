class Changeset
  include Mongoid::History::Tracker

  has_many :change_syncs

  alias :person :trackable_root
end
class Changeset
  include Mongoid::History::Tracker

  alias :person :trackable_root
end
class Address
  include Mongoid::Document
  include Mongoid::History::Trackable

  TYPES = [:home]

  embedded_in :person

  field :type, type: Symbol
  field :street_1, type: String
  field :street_2, type: String
  field :city, type: String
  field :state, type: String
  field :zip, type: String
  field :country, type: String

  validates :type, presence: true, inclusion: { in: Address::TYPES }
  validates :street_1, presence: true

  track_history track_create: true, track_destroy: true
end
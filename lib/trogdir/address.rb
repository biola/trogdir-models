class Address
  include Mongoid::Document

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
end
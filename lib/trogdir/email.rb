class Email
  include Mongoid::Document
  embedded_in :person

  TYPES = [:university, :personal]

  field :type, type: Symbol
  field :address, type: String
  field :primary, type: Boolean

  validates :type, presence: true, inclusion: { in: Email::TYPES }
  validates :address, presence: true, email: true
end
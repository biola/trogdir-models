class Email
  include Mongoid::Document
  include Mongoid::History::Trackable

  embedded_in :person

  TYPES = [:university, :personal]

  field :type, type: Symbol
  field :address, type: String
  field :primary, type: Boolean, default: false

  validates :type, presence: true, inclusion: { in: Email::TYPES }
  validates :address, presence: true, email: true

  track_history track_create: true, track_destroy: true
end
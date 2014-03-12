class Phone
  include Mongoid::Document

  TYPES = [:office, :home, :cell]

  embedded_in :person

  field :type, type: Symbol
  field :number, type: String
  field :primary, type: Boolean

  validates :type, presence: true, inclusion: { in: Phone::TYPES }
  validates :number, presence: true
end
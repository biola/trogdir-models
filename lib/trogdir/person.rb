class Person
  include Mongoid::Document
  include Student
  include Employee

  embeds_many :ids, class_name: 'ID'
  embeds_many :emails
  embeds_many :photos
  embeds_many :phones

  # Names
  field :first_name, type: String
  field :preferred_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :display_name, type: String

  # Demographic
  field :gender, type: Symbol
  field :partial_ssn, type: String
  field :birth_date, type: Date

  # Groups and permissions
  field :entitlements, type: Array
  field :affiliations, type: Array

  # Options
  field :privacy, type: Boolean
  field :enabled, type: Boolean # TODO: figure out if tihs is necessary

  validates :first_name, :last_name, presence: true

  def email
    emails.where(primary: true).first
  end

  delegate :address, to: :email, prefix: true, allow_nil: true
end
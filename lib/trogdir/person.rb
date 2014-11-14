require 'securerandom'

class Person
  include Mongoid::Document
  include Mongoid::History::Trackable
  include Student
  include Employee

  GENDERS = [:male, :female]

  embeds_many :ids, class_name: 'ID'
  embeds_many :emails
  embeds_many :photos
  embeds_many :phones
  embeds_many :addresses

  # ID
  field :uuid, type: String

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
  field :groups, type: Array

  # Options
  field :enabled, type: Boolean # TODO: figure out if tihs is necessary

  # For sorting
  index last_name: 1, preferred_name: 1

  # For searching
  index({uuid: 1}, unique: true)
  index affiliations: 1
  index first_name: 1
  index preferred_name: 1
  index last_name: 1
  index display_name: 1
  index title_name: 1
  index department_name: 1
  index residence_name: 1
  index 'emails.address' => 1
  index 'ids.identifier' => 1
  index({'ids.identifier' => 1, 'ids.type' => 1}, unique: true)

  validates :uuid, :first_name, :last_name, presence: true
  validates :uuid, uniqueness: true
  validates :gender, inclusion: { in: Person::GENDERS, allow_nil: true }

  track_history track_create: true

  before_validation :set_uuid, on: :create

  def changesets
    # association_hash is provided by Mongoid::History::Trackable
    # history_tracks would only get changes to the 'person' scope this also gets changes to associated models
    Mongoid::History.tracker_class.where(association_chain: association_hash)
  end

  def email
    emails.where(primary: true).first
  end

  delegate :address, to: :email, prefix: true, allow_nil: true

  private

  def set_uuid
    self.uuid = SecureRandom.uuid
  end
end

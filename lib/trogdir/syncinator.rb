require 'securerandom'

class Syncinator
  include Mongoid::Document

  FIXNUM_MAX = (2**(0.size * 8 -2) -1)

  field :name, type: String
  field :slug, type: String
  field :access_id, type: Integer
  field :secret_key, type: String
  field :queue_changes, type: Boolean
  field :active, type: Boolean

  attr_readonly :slug, :access_id, :secret_key

  validates :name, :slug, :access_id, :secret_key, presence: true
  validates :name, :slug, :access_id, :secret_key, uniqueness: true

  before_validation :set_default_slug, :set_access_id, :set_secret_key, on: :create

  def to_s
    name
  end

  private

  def set_default_slug
    self.slug ||= name.parameterize
  end

  def set_access_id
    self.access_id = rand(FIXNUM_MAX)
  end

  def set_secret_key
    self.secret_key = SecureRandom.hex(64)
  end
end
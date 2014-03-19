class ID
  include Mongoid::Document
  include Mongoid::History::Trackable

  TYPES = [:biola_id, :netid, :banner, :google_apps]
  DEFAULT_TYPE = :netid

  embedded_in :person
  field :type, type: Symbol
  field :identifier

  validates :type, presence: true, inclusion: { in: ID::TYPES }
  validates :identifier, presence: true
  validate do |id|
    if Person.where(:id.ne => id.person.try(:id), 'ids.identifier' => id.identifier, 'ids.type' => id.type).count > 0
      id.errors.add :identifier, 'must be unique'
    end
  end

  track_history track_create: true, track_destroy: true

  def to_s
    identifier
  end
end
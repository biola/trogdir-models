class ID
  include Mongoid::Document
  include Mongoid::History::Trackable

  TYPES = [:biola_id, :netid, :banner, :google_apps]
  DEFAULT_TYPE = :netid

  embedded_in :person
  field :type, type: Symbol
  field :identifier, type: String

  validates :type, presence: true, inclusion: { in: ID::TYPES }
  validates :identifier, presence: true
  validates :identifier, uniqueness: {scope: :type}
  validate do |id|
    if Person.where(:id.ne => id.person.try(:id), :ids.elem_match => {identifier: id.identifier, type: id.type}).count > 0
      id.errors.add :identifier, 'must be unique'
    end
  end

  track_history changes_method: :track_type, track_create: true, track_destroy: true

  def to_s
    identifier
  end

  private
  def track_type
    if changes.include? 'type'
      changes
    else
      changes.merge("type" => [type, type])
    end
  end
end

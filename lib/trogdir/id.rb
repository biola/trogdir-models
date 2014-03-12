class ID
  include Mongoid::Document

  TYPES = [:biola_id, :netid, :banner, :google_apps]

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

  def to_s
    identifier
  end
end
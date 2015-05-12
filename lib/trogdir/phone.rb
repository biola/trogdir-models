class Phone
  include Mongoid::Document
  include Mongoid::History::Trackable

  TYPES = [:office, :home, :cell]

  embedded_in :person

  field :type, type: Symbol
  field :number, type: String
  field :primary, type: Boolean, default: false

  validates :type, presence: true, inclusion: { in: Phone::TYPES }
  validates :number, presence: true

  track_history changes_method: :track_type, track_create: true, track_destroy: true

  private
  def track_type
    if changes.include? 'type'
      changes
    else
      changes.merge("type" => [type, type])
    end
  end
end

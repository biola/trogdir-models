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

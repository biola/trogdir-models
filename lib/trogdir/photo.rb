class Photo
  include Mongoid::Document
  include Mongoid::History::Trackable

  TYPES = [:id_card]

  embedded_in :person

  field :type, type: Symbol
  field :url, type: String
  field :height, type: Integer
  field :width, type: Integer

  validates :type, presence: true, inclusion: { in: Photo::TYPES }
  validates :url, :height, :width, presence: true
  validates :url, absolute_uri: true

  track_history track_create: true, track_destroy: true
end
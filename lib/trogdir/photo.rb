class Photo
  include Mongoid::Document

  TYPES = [:id_card]

  embedded_in :person

  field :type, type: Symbol
  field :url, type: String
  field :height, type: Integer
  field :width, type: Integer

  validates :type, presence: true, inclusion: { in: Photo::TYPES }
  validates :url, :height, :width, presence: true
  validates :url, absolute_uri: true
end
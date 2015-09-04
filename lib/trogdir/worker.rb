class Worker
  include Mongoid::Document
  include Mongoid::Userstamp::User

  embedded_in :syncinator

  field :name, type: String
  field :scheduled_for, type: DateTime
  field :sidekiq_id, type: String

  validates :name, :sidekiq_id, presence: true
  validates :name, uniqueness: true

  def to_s
    name
  end
end

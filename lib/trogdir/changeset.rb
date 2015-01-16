class Changeset
  include Mongoid::History::Tracker
  include Mongoid::Userstamp

  mongoid_userstamp user_model: 'Syncinator'

  embeds_many :change_syncs

  index created_at: -1
  index 'change_syncs.syncinator_id' => 1
  index 'change_syncs.started_at' => 1
  index 'change_syncs.succeeded_at' => 1
  index({'change_syncs._id' => 1}, unique: true, sparse: true)
  index({'change_syncs.sync_logs._id' => 1}, unique: true, sparse: true)

  after_create :create_change_syncs

  alias :person :trackable_root

  private

  def create_change_syncs
    Syncinator.where(active: true, queue_changes: true).each do |syncinator|
      change_syncs.create syncinator: syncinator
    end
  end
end

class Changeset
  include Mongoid::History::Tracker
  include Mongoid::Userstamp

  mongoid_userstamp user_model: 'Syncinator'

  embeds_many :change_syncs


  field :modified_by, type: String
  field :reason, type: String
  index created_at: -1
  index 'change_syncs.syncinator_id' => 1
  index 'change_syncs.run_after' => 1
  index 'change_syncs.sync_logs.started_at' => 1
  index 'change_syncs.sync_logs.errored_at' => 1
  index 'change_syncs.sync_logs.succeeded_at' => 1
  index({'change_syncs._id' => 1}, {unique: true, sparse: true})
  index({'change_syncs.sync_logs._id' => 1}, {unique: true, sparse: true})
  index('change_syncs.syncinator_id' => 1, 'change_syncs.run_after' => 1)

  before_save :tag_user
  after_create :create_change_syncs

  alias :person :trackable_root

  private

  def tag_user
    self.modified_by = ENV["SUDO_USER"] || ENV["USER"] || ""
  end

  def create_change_syncs
    Syncinator.where(active: true, queue_changes: true).each do |syncinator|
      change_syncs.create syncinator: syncinator
    end
  end
end

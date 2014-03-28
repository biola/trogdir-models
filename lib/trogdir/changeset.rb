class Changeset
  include Mongoid::History::Tracker

  embeds_many :change_syncs

  after_create :create_change_syncs

  alias :person :trackable_root

  private

  def create_change_syncs
    Syncinator.where(active: true, queue_changes: true).each do |syncinator|
      change_syncs.create syncinator: syncinator
    end
  end
end
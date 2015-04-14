class ChangeSync
  include Mongoid::Document

  embedded_in :changeset
  belongs_to :syncinator
  embeds_many :sync_logs
  field :run_after, type: Time, default: -> { Time.now - 1 }

  before_save :update_run_after

  def status
    @status ||= if sync_logs.any? { |sl| sl.succeeded_at? }
      :succeeded
    elsif sync_logs.to_a.find { |sl| sl.errored_at? }
      :errored
    elsif sync_logs.to_a.find { |sl| sl.started_at? }
      :pending
    else
      :unsynced
    end
  end

  def latest_sync_log
    sync_logs.asc(:started_at).last
  end

  def update_run_after
    self.run_after = if sync_logs.any? { |sl| sl.succeeded_at_changed? }
      nil
    elsif sync_logs.to_a.find { |sl| sl.errored_at_changed? }
      # wait exponentially longer between retries the more it fails
      latest_sync_log.errored_at + (sync_logs.length**4).minutes
    elsif sync_logs.to_a.find { |sl| sl.started_at_changed? }
      latest_sync_log.started_at + 1.hour
    else
      run_after
    end
  end
end

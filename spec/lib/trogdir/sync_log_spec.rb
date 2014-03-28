require 'spec_helper'

describe SyncLog do
  it { should be_embedded_in :change_sync }

  it { should have_field(:started_at).of_type Time }
  it { should have_field(:errored_at).of_type Time }
  it { should have_field(:succeeded_at).of_type Time }
  it { should have_field(:action).of_type Symbol }
  it { should have_field(:message).of_type String }

  it { should validate_presence_of :started_at }

  it { should respond_to :changeset }
  it { should respond_to :syncinator }

  describe '.find_through_parents' do
    let!(:sync_log) { create :sync_log }

    it "returns a sync log by it's ID" do
      expect(SyncLog.find_through_parents(sync_log.id.to_s)).to eql sync_log
    end
  end
end
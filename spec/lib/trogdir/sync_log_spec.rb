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

  context 'before_save' do
    subject { create :sync_log, succeeded_at: nil }

    describe '#update_change_sync' do
      context 'when started_at is changed' do
        it 'sets run_after to 1 hour' do
          expect(subject.change_sync.run_after).to be_between(59.minutes.from_now, 1.hour.from_now)
        end
      end

      context 'when errored_at is changed' do
        context 'after 1 error' do
          it 'sets run_after to 1 minute' do
            expect { subject.update(errored_at: Time.now) }.to change { subject.change_sync.run_after }
            expect(subject.change_sync.run_after).to be_between(55.seconds.from_now, 1.minute.from_now)
          end
        end
      end

      context 'when succeeded_at is changed' do
        it 'sets run_after to nil' do
          expect { subject.update(succeeded_at: Time.now) }.to change { subject.reload.change_sync.run_after }.to(nil)
        end
      end
    end
  end
end

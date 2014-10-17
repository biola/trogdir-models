require 'spec_helper'

describe Syncinator do
  let(:attrs) { {} }
  let(:syncinator) { build :syncinator, attrs }

  it { should have_field(:name).of_type String }
  it { should have_field(:slug).of_type String }
  it { should have_field(:access_id).of_type Integer }
  it { should have_field(:secret_key).of_type String }
  it { should have_field(:queue_changes).of_type Mongoid::Boolean }
  it { should have_field(:active).of_type Mongoid::Boolean }

  [:slug, :access_id, :secret_key].each do |attr|
    it 'raises an error when changing a read-only attribute' do
      syncinator.save!
      expect { syncinator.update_attribute(attr, 'blah') }.to raise_error Mongoid::Errors::ReadonlyAttribute
    end
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }
  it { should validate_presence_of :access_id }
  it { should validate_presence_of :secret_key }

  it { should validate_uniqueness_of :name }
  it { should validate_uniqueness_of :slug }
  it { should validate_uniqueness_of :access_id }
  it { should validate_uniqueness_of :secret_key }

  context 'without a slug' do
    let(:attrs) { {name: 'I dunno'} }

    it 'automatically assigns a slug' do
      expect { syncinator.save! }.to change { syncinator.slug }.from(nil).to 'i-dunno'
    end
  end

  describe '#access_id' do
    it 'is automatically assigned' do
      expect { syncinator.save! }.to change { syncinator.access_id }.from(nil).to Integer
    end

    it 'is a Fixnum' do
      syncinator.save!
      expect(syncinator.access_id).to be_a Fixnum
    end
  end

  describe '#secret_key' do
    it 'is automatically assigned' do
      expect { syncinator.save! }.to change { syncinator.secret_key }.from(nil).to String
    end

    it 'is a Base64 encoded, randomized string' do
      syncinator.save!
      expect(syncinator.secret_key).to match /[0-9a-zA-Z+\/]{86}==/
    end
  end

  describe '#startable_changesets' do
    subject { syncinator.startable_changesets }

    context 'without an assigned change_sync' do
      it { should be_empty }
    end

    context 'with two change_syncs for two syncinators' do
      let!(:syncinator) { create :syncinator }
      let!(:other_syncinator) { create :syncinator }
      let(:changeset) { create(:person).history_tracks.last }
      let(:change_sync) { changeset.change_syncs.to_a.find{|cs| cs.syncinator == syncinator} }
      let(:other_change_sync) { changeset.change_syncs.to_a.find{|cs| cs.syncinator == other_syncinator} }

      context 'with the subjects change_sync succeeded' do
        before { change_sync.sync_logs.create! started_at: 2.minute.ago, succeeded_at: 1.minute.ago }
        it { should be_empty }
      end

      context "with the other's change_sync succeeded" do
        before { other_change_sync.sync_logs.create! started_at: 2.minute.ago, succeeded_at: 1.minute.ago }
        it { should_not be_empty }
      end
    end

    context 'with an assigned change_sync' do
      let!(:syncinator) { create :syncinator }
      let!(:changeset) { create(:person).history_tracks.last }

      context 'with an unstarted change_sync' do
        it { expect(subject.first).to be_a Changeset }
      end

      context 'with a succeeded change_sync' do
        before { changeset.change_syncs.last.sync_logs.create! started_at: 2.minute.ago, succeeded_at: 1.minute.ago }
        it { should be_empty }
      end

      context 'with a succeeded change_sync' do
        before { changeset.change_syncs.last.sync_logs.create! started_at: 2.minute.ago, succeeded_at: 1.minute.ago }
        it { should be_empty }
      end

      context 'with a recently errored change_sync' do
        before { changeset.change_syncs.last.sync_logs.create! started_at: 30.seconds.ago, errored_at: 10.seconds.ago }
        it { should be_empty }
      end

      context 'with a long ago errored change_sync' do
        before { changeset.change_syncs.last.sync_logs.create! started_at: 65.minutes.ago, errored_at: 64.minutes.ago }
        it { expect(subject.first).to be_a Changeset }
      end

      context 'with a long ago errored but recently succeeded change_sync' do
        before do
          changeset.change_syncs.last.sync_logs.create! started_at: 65.minutes.ago, errored_at: 64.minutes.ago
          changeset.change_syncs.last.sync_logs.create! started_at: 2.minute.ago, succeeded_at: 1.minute.ago
        end

        it { should be_empty }
      end
    end
  end

  describe '#start!' do
    let!(:syncinator) { create :syncinator }
    let!(:changeset) { create(:person).history_tracks.last }

    it 'adds a new sync_log with a starts_at' do
      expect { syncinator.start!(changeset) }.to change { changeset.change_syncs.first.sync_logs.count }.from(0).to 1
    end

    it 'returns a sync_log' do
      expect(syncinator.start!(changeset)).to be_a SyncLog
    end
  end

  describe '#error!' do
    let!(:syncinator) { create :syncinator }
    let!(:changeset) { create(:person).history_tracks.last }
    let(:sync_log) { syncinator.start!(changeset) }
    let(:message) { 'OH NOES!'}
    subject { syncinator.error!(sync_log, message) }

    it 'updates the sync_log' do
      expect(subject.errored_at).to be_a Time
      expect(subject.succeeded_at).to be_nil
      expect(subject.message).to eql message
    end

    it 'returns a sync_log' do
      expect(subject).to be_a SyncLog
    end
  end

  describe '#finish!' do
    let!(:syncinator) { create :syncinator }
    let!(:changeset) { create(:person).history_tracks.last }
    let(:sync_log) { syncinator.start!(changeset) }
    let(:action) { :created }
    let(:message) { 'Finally!'}
    subject { syncinator.finish!(sync_log, action, message) }

    it 'updates the sync_log' do
      expect(subject.errored_at).to be_nil
      expect(subject.succeeded_at).to be_a Time
      expect(subject.action).to eql action
      expect(subject.message).to eql message
    end

    it 'returns a sync_log' do
      expect(subject).to be_a SyncLog
    end
  end
end

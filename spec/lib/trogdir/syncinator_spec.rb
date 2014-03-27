require 'spec_helper'

describe Syncinator do
  let(:attrs) { {} }
  let(:syncinator) { build :syncinator, attrs }

  it { should have_field(:name).of_type String }
  it { should have_field(:slug).of_type String }
  it { should have_field(:access_id).of_type Integer }
  it { should have_field(:secret_key).of_type String }
  it { should have_field(:queue_changes).of_type Boolean }
  it { should have_field(:active).of_type Boolean }

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
    let(:retry_after) { 1.hour.ago }
    subject { syncinator.startable_changesets(retry_after) }

    context 'without an assigned change_sync' do
      it { should be_empty }
    end

    context 'with an assigned change_sync' do
      let!(:syncinator) { create :syncinator }
      let!(:changeset) { create(:person).history_tracks.last }

      context 'with an unstarted change_sync' do
        its(:first) { should be_a Changeset }
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
        before { changeset.change_syncs.last.sync_logs.create! started_at: 2.minute.ago, errored_at: 1.minute.ago }
        it { should be_empty }
      end

      context 'with a long ago errored_change_sync' do
        before { changeset.change_syncs.last.sync_logs.create! started_at: 65.minutes.ago, errored_at: 64.minutes.ago }
        its(:first) { should be_a Changeset }
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
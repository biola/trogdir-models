require 'spec_helper'

describe ChangeSync do
  it { should be_embedded_in :changeset }
  it { should belong_to :syncinator }
  it { should embed_many :sync_logs }
  it { should have_field(:run_after).of_type Time }

  it 'has a run_after date by default' do
    expect(subject.run_after).to be_a Time
  end
end

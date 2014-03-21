require 'spec_helper'

describe SyncLog do
  it { should belong_to :change_sync }

  it { should have_field(:started_at).of_type Time }
  it { should have_field(:errored_at).of_type Time }
  it { should have_field(:succeeded_at).of_type Time }
  it { should have_field(:action).of_type Symbol }
  it { should have_field(:message).of_type String }

  it { should validate_presence_of :started_at }
end
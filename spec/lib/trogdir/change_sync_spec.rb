require 'spec_helper'

describe ChangeSync do
  it { should belong_to :changeset }
  it { should belong_to :syncinator }
  it { should embed_many :sync_logs }
end
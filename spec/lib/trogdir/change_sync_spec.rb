require 'spec_helper'

describe ChangeSync do
  it { should belong_to :changeset }
  it { should belong_to :syncinator }
end
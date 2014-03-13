require 'spec_helper'

describe Phone do
  it { should be_embedded_in :person }

  it { should have_field(:type).of_type Symbol }
  it { should have_field(:number).of_type String }
  it { should have_field(:primary).of_type Boolean }

  it { should validate_presence_of :type }
  it { should validate_presence_of :number }
end
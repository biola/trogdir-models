require 'spec_helper'

describe Address do
  it { should be_embedded_in :person }

  it { should have_field(:type).of_type Symbol }
  it { should have_field(:street_1).of_type String }
  it { should have_field(:street_2).of_type String }
  it { should have_field(:city).of_type String }
  it { should have_field(:state).of_type String }
  it { should have_field(:zip).of_type String }
  it { should have_field(:country).of_type String }

  it { should validate_presence_of :type }
  it { should validate_inclusion_of(:type).to_allow Address::TYPES }
  it { should validate_presence_of :street_1 }
end
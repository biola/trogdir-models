require 'spec_helper'

describe Address do
  it { should be_embedded_in :person }

  it { should respond_to :type }
  it { should respond_to :street_1 }
  it { should respond_to :street_2 }
  it { should respond_to :city }
  it { should respond_to :state }
  it { should respond_to :zip }
  it { should respond_to :country }

  it { should validate_presence_of :type }
  it { should validate_inclusion_of(:type).to_allow Address::TYPES }
  it { should validate_presence_of :street_1 }
end
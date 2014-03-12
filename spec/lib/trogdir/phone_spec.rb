require 'spec_helper'

describe Phone do
  it { should be_embedded_in :person }

  it { should respond_to :type }
  it { should respond_to :number }
  it { should respond_to :primary }

  it { should validate_presence_of :type }
  it { should validate_presence_of :number }
end
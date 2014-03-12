require 'spec_helper'

describe Person do
  # Person methods
  it { should respond_to :first_name }
  it { should respond_to :preferred_name }
  it { should respond_to :middle_name }
  it { should respond_to :last_name }
  it { should respond_to :display_name }
  it { should respond_to :gender }
  it { should respond_to :partial_ssn }
  it { should respond_to :birth_date }
  it { should respond_to :entitlements }
  it { should respond_to :affiliations }
  it { should respond_to :privacy }
  it { should respond_to :enabled }

  # Student concern methods
  it { should respond_to :residence }
  it { should respond_to :floor }
  it { should respond_to :wing }
  it { should respond_to :majors }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
end
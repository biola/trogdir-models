require 'spec_helper'

describe Person do
  let(:person) { create :person }

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

  # Employee concerns methods
  it { should respond_to :department }
  it { should respond_to :title }
  it { should respond_to :employee_type }
  it { should respond_to :full_time }
  it { should respond_to :pay_type }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }

  describe '#email' do
    let(:email) { person.email }

    context 'when multiple_emails' do
      let!(:email_a) { create :email, person: person, address: 'john@example.com', primary: false }
      let!(:email_b) { create :email, person: person, address: 'johnny@example.com', primary: true }

      it 'returns the primary' do
        expect(email).to eq email_b
      end
    end

    context 'when no emails' do
      it 'returns nil' do
        expect(email).to be_nil
      end
    end
  end
end
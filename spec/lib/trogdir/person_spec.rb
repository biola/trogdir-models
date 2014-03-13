require 'spec_helper'

describe Person do
  let(:person) { create :person }

  it { should embed_many :ids }
  it { should embed_many :emails }
  it { should embed_many :photos }
  it { should embed_many :phones }
  it { should embed_many :addresses }

  # Person methods
  it { should have_field(:first_name).of_type String }
  it { should have_field(:preferred_name).of_type String }
  it { should have_field(:middle_name).of_type String }
  it { should have_field(:last_name).of_type String }
  it { should have_field(:display_name).of_type String }
  it { should have_field(:gender).of_type Symbol }
  it { should have_field(:partial_ssn).of_type String }
  it { should have_field(:birth_date).of_type Date }
  it { should have_field(:entitlements).of_type Array }
  it { should have_field(:affiliations).of_type Array }
  it { should have_field(:privacy).of_type Boolean }
  it { should have_field(:enabled).of_type Boolean }

  # Student concern methods
  it { should have_field(:residence).of_type String }
  it { should have_field(:floor).of_type Integer }
  it { should have_field(:wing).of_type String }
  it { should have_field(:majors).of_type Array }

  # Employee concerns methods
  it { should have_field(:department).of_type String }
  it { should have_field(:title).of_type String }
  it { should have_field(:employee_type).of_type Symbol }
  it { should have_field(:full_time).of_type Boolean }
  it { should have_field(:pay_type).of_type Symbol }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }

  describe '#email' do
    let(:email) { person.email }
    let(:email_address) { person.email_address }

    context 'when multiple_emails' do
      let!(:email_a) { create :email, person: person, address: 'john@example.com', primary: false }
      let!(:email_b) { create :email, person: person, address: 'johnny@example.com', primary: true }

      it 'returns the primary' do
        expect(email).to eq email_b
        expect(email_address).to eq email_b.address
      end
    end

    context 'when no emails' do
      it 'returns nil' do
        expect(email).to be_nil
        expect(email_address).to be_nil
      end
    end
  end
end
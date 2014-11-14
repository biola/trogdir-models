require 'spec_helper'

describe Person do
  let(:person) { create :person }

  it { should embed_many :ids }
  it { should embed_many :emails }
  it { should embed_many :photos }
  it { should embed_many :phones }
  it { should embed_many :addresses }

  # Person methods
  it { should have_field(:uuid).of_type String }
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
  it { should have_field(:groups).of_type Array }
  it { should have_field(:enabled).of_type Mongoid::Boolean }

  # Student concern methods
  it { should have_field(:residence).of_type String }
  it { should have_field(:floor).of_type Integer }
  it { should have_field(:wing).of_type String }
  it { should have_field(:majors).of_type Array }
  it { should have_field(:privacy).of_type Mongoid::Boolean }

  # Employee concerns methods
  it { should have_field(:department).of_type String }
  it { should have_field(:title).of_type String }
  it { should have_field(:employee_type).of_type Symbol }
  it { should have_field(:full_time).of_type Mongoid::Boolean }
  it { should have_field(:pay_type).of_type Symbol }

  it { should validate_presence_of :uuid }
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_uniqueness_of :uuid }
  it { should validate_inclusion_of(:gender).to_allow Person::GENDERS }

  describe '#uuid' do
    let(:person) { build :person }
    before { person.valid? } # trigger generation of uuid
    it { expect(person.uuid).to match /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\Z/ }
  end

  describe '#changesets' do
    context 'when person has been changed' do
      before { person.update(last_name: 'Bad') }

      it 'returns changesets for person' do
        expect(person.changesets.length).to eql 2 # create and update
        expect(person.changesets.last.modified).to eql 'last_name' => 'Bad'
      end

      context 'when an embedded model added' do
        before { person.emails.create type: 'university', address: 'strong.bad@example.com' }

        it 'returns changesets for person' do
          expect(person.changesets.length).to eql 3 # create person, update person and create email
          expect(person.changesets.last.modified).to eql 'type' => :university, 'address' => 'strong.bad@example.com', 'primary' => false
        end
      end
    end
  end

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

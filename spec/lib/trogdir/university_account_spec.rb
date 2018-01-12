require 'spec_helper'

describe UniversityAccount do
  it { expect(described_class).to be < Account }

  it { should belong_to :person }

  it { should have_field(:confirmation_key).of_type(String) }
  it { should have_field(:confirmed_at).of_type(DateTime) }
  it { should have_field(:referring_url).of_type(String) }
  it { should have_field(:return_url).of_type(String) }

  it 'sets confirmation_key on create' do
    university_account = build :university_account
    expect(university_account.confirmation_key).to be nil
    expect(university_account.save).to be true
    expect(university_account.confirmation_key.length).to be > 5
  end

  describe '#unconfirmed?' do
    context 'confirmed_at is not set' do
      Given (:university_account) { build :university_account, confirmed_at: nil }
      Then { university_account.unconfirmed? }
    end

    context 'confirmed_at is in the past' do
      Given (:university_account) { build :university_account, confirmed_at: 1.day.ago }
      Then { university_account.unconfirmed? == false }
    end
  end
end

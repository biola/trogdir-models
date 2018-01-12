require 'spec_helper'

describe Account do
  it { should belong_to :person }

  it { should have_field(:confirmation_key).of_type(String) }
  it { should have_field(:confirmed_at).of_type(DateTime) }
  it { should have_field(:referring_url).of_type(String) }
  it { should have_field(:return_url).of_type(String) }

  it 'sets confirmation_key on create' do
    account = build :account
    expect(account.confirmation_key).to be nil
    expect(account.save).to be true
    expect(account.confirmation_key.length).to be > 5
  end

  describe '#unconfirmed?' do
    context 'confirmed_at is not set' do
      Given(:account) { build :account, confirmed_at: nil }
      Then { account.unconfirmed? }
    end

    context 'confirmed_at is in the past' do
      Given(:account) { build :account, confirmed_at: 1.day.ago }
      Then { account.unconfirmed? == false }
    end
  end
end

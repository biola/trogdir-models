require 'spec_helper'

describe GuestAccount do
  it { should belong_to :person }

  it { should have_field(:uuid).of_type(String) }

  it { should have_field(:first_name).of_type(String) }
  it { should validate_presence_of :first_name }

  it { should have_field(:last_name).of_type(String) }
  it { should validate_presence_of :last_name }

  it { should have_field(:username).of_type(String) }
  it { should validate_presence_of :username }
  it { should validate_uniqueness_of(:username).scoped_to(:type) }

  it { should have_field(:email).of_type(String) }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).scoped_to(:type) }
  describe 'email' do
    [
      ['foo@example.com', true],
      ['foo@', false],
      ['foo@2343', false],
      ['foo@2343.a', true],
    ].each do |email, valid|
      context email do
        Given(:guest_account) { build :guest_account, email: email }
        Then { guest_account.valid? == valid }
      end
    end
  end

  it { should have_field(:password_digest).of_type(String) }
  it { should have_field(:confirmation_key).of_type(String) }
  it { should have_field(:confirmed_at).of_type(DateTime) }
  it { should have_field(:referring_url).of_type(String) }
  it { should have_field(:return_url).of_type(String) }
  it { should have_field(:password_reset_key).of_type(String) }
  it { should have_field(:password_reset_email_sent_at).of_type(DateTime) }
  it { should have_field(:password_updated_at).of_type(DateTime) }

  it 'sets the uuid before validation' do
    guest_account = build :guest_account
    expect(guest_account.uuid).to be nil
    expect(guest_account.valid?).to be true
    expect(guest_account.uuid).not_to be nil
    expect(guest_account.uuid.length).to eq 36 # uuid standard length
    expect(guest_account.uuid).to match(
      /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\Z/
    )
  end

  it 'it downcases the email before validation' do
    guest_account = build :guest_account, email: 'FoObAr@YaHOo.Com'
    expect(guest_account.email).to eq('FoObAr@YaHOo.Com')
    expect(guest_account.valid?).to be true
    expect(guest_account.email).to eq('FoObAr@YaHOo.Com'.downcase)
  end

  it 'sets username to the downcased email if no username is given' do
    guest_account =
      build :guest_account, username: nil, email: 'FoObAr@YaHOo.Com'
    expect(guest_account.username).to be nil
    expect(guest_account.valid?).to be true
    expect(guest_account.username).to eq 'FoObAr@YaHOo.Com'.downcase
  end

  it 'sets confirmation_key on create' do
    guest_account = build :guest_account
    expect(guest_account.confirmation_key).to be nil
    expect(guest_account.save).to be true
    expect(guest_account.confirmation_key.length).to be > 5
  end

  describe '#unconfirmed?' do
    context 'confirmed_at is not set' do
      Given(:guest_account) { build :guest_account, confirmed_at: nil }
      Then { guest_account.unconfirmed? }
    end

    context 'confirmed_at is in the past' do
      Given(:guest_account) { build :guest_account, confirmed_at: 1.day.ago }
      Then { guest_account.unconfirmed? == false }
    end
  end

  describe '#archive!' do
    it 'sets a timestamp on archived_at and saves the record' do
      guest_account = build :guest_account
      expect(guest_account.archived_at).to be nil
      expect(guest_account.archived?).to be false
      expect(guest_account.archive!).to be true
      expect(guest_account.archived?).to be true
      expect(guest_account.archived_at).not_to be nil
    end
  end

  describe '#archived?' do
    it 'returns false if archived_at is not nil, true otherwise' do
      guest_account = build :guest_account
      expect(guest_account.archived?).to be false
      guest_account.archive!
      expect(guest_account.archived?).to be true
      guest_account.unarchive!
      expect(guest_account.archived?).to be false
    end
  end

  describe '#unarchive!' do
    it 'sets a timestamp on archived_at and saves the record' do
      guest_account = build :guest_account
      guest_account.archive!
      expect(guest_account.archived_at).not_to be nil
      expect(guest_account.unarchive!).to be true
      expect(guest_account.archived_at).to be nil
    end
  end

  describe 'history tracking' do
    it 'tracks on create' do
      guest_account = build :guest_account
      expect(AccountHistoryTracker.count).to eq 0
      guest_account.save
      expect(AccountHistoryTracker.count).to eq 1
    end

    it 'tracks on update' do
      guest_account = build :guest_account
      guest_account.save
      expect(AccountHistoryTracker.count).to eq 1
      guest_account.first_name = 'Steve'
      guest_account.save
      expect(AccountHistoryTracker.count).to eq 2
    end
  end
end

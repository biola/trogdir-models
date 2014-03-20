require 'spec_helper'

describe Syncinator do
  let(:attrs) { {} }
  let(:syncinator) { build :syncinator, attrs }

  it { should have_many(:change_syncs) }

  it { should have_field(:name).of_type String }
  it { should have_field(:slug).of_type String }
  it { should have_field(:access_id).of_type Integer }
  it { should have_field(:secret_key).of_type String }
  it { should have_field(:queue_changes).of_type Boolean }
  it { should have_field(:active).of_type Boolean }

  [:slug, :access_id, :secret_key].each do |attr|
    it 'raises an error when changing a read-only attribute' do
      syncinator.save!
      expect { syncinator.update_attribute(attr, 'blah') }.to raise_error Mongoid::Errors::ReadonlyAttribute
    end
  end

  it { should validate_presence_of :name }
  it { should validate_presence_of :slug }
  it { should validate_presence_of :access_id }
  it { should validate_presence_of :secret_key }

  it { should validate_uniqueness_of :name }
  it { should validate_uniqueness_of :slug }
  it { should validate_uniqueness_of :access_id }
  it { should validate_uniqueness_of :secret_key }

  context 'without a slug' do
    let(:attrs) { {name: 'I dunno'} }

    it 'automatically assigns a slug' do
      expect { syncinator.save! }.to change { syncinator.slug }.from(nil).to 'i-dunno'
    end
  end

  describe '#access_id' do
    it 'is automatically assigned' do
      expect { syncinator.save! }.to change { syncinator.access_id }.from(nil).to Integer
    end

    it 'is a Fixnum' do
      syncinator.save!
      expect(syncinator.access_id).to be_a Fixnum
    end
  end

  describe '#secret_key' do
    it 'is automatically assigned' do
      expect { syncinator.save! }.to change { syncinator.secret_key }.from(nil).to String
    end

    it 'is a Base64 encoded, randomized string' do
      syncinator.save!
      expect(syncinator.secret_key).to match /[0-9a-zA-Z+\/]{86}==/
    end
  end
end
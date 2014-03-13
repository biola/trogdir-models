require 'spec_helper'

describe ID do
  let(:attrs) { {} }
  subject { build :id, attrs }

  it { should be_embedded_in :person }

  it { should have_field(:type).of_type Symbol }
  it { should have_field :identifier }

  it { should validate_presence_of :type }
  it { should validate_inclusion_of(:type).to_allow ID::TYPES }
  it { should validate_presence_of :identifier }

  describe 'uniqueness validation' do
    before { create(:id, identifier: 'johnd0', type: :netid) }

    context 'with a duplicate identifier and type' do
      let(:attrs) { {identifier: 'johnd0', type: :netid} }
      it { should be_invalid }
    end

    context 'with a duplicate identifier and different type' do
      let(:attrs) { {identifier: 'johnd0', type: :google_apps} }
      it { should be_valid }
    end
  end

  describe '#identifier' do
    context 'when an integer' do
      let(:attrs) { {identifier: 42} }
      its(:identifier) { should be_kind_of Integer }
    end

    context 'when a string' do
      let(:attrs) { {identifier: 'deepthought'} }
      its(:identifier) { should be_kind_of String }
    end
  end

  describe '#to_s' do
    let(:attrs) { {identifier: 'imastring'} }
    its(:to_s) { should eql 'imastring' }
  end
end
require 'spec_helper'

describe ID do
  let(:attrs) { {} }
  subject { build :id, attrs }

  it { should respond_to :identifier }
  it { should respond_to :type }

  it { should validate_presence_of :type }
  it { should ensure_inclusion_of(:type).in_array ID::TYPES }
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
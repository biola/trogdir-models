require 'spec_helper'

describe Photo do
  let(:attrs) { {} }
  subject { build :photo, attrs }

  it { should be_embedded_in :person }

  it { should respond_to :type }
  it { should respond_to :url }
  it { should respond_to :height }
  it { should respond_to :width }

  it { should validate_presence_of :type }
  it { should validate_inclusion_of(:type).to_allow Photo::TYPES }
  it { should validate_presence_of :url }
  it { should validate_presence_of :height }
  it { should validate_presence_of :width }

  describe 'absolute_url validation' do
    context 'valid URL' do
      let(:attrs) { {url: 'http://example.com/photo.jpg'} }
      it { should be_valid }
    end

    context 'invalid URL' do
      let(:attrs) { {url: '/whatever.jpg'} }
      it { should be_invalid }
    end
  end
end
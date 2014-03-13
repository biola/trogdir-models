require 'spec_helper'

describe Photo do
  let(:attrs) { {} }
  subject { build :photo, attrs }

  it { should be_embedded_in :person }

  it { should have_fields(:type).of_type Symbol }
  it { should have_fields(:url).of_type String }
  it { should have_fields(:height).of_type Integer }
  it { should have_fields(:width).of_type Integer }

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
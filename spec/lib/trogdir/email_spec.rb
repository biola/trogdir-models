require 'spec_helper'

describe Email do
  let(:attrs) { {} }
  subject { build :email, attrs }

  it { should be_embedded_in :person }

  it { should respond_to :type }
  it { should respond_to :address }
  it { should respond_to :primary? }

  it { should validate_presence_of :type }
  it { should validate_inclusion_of(:type).to_allow Email::TYPES }
  it { should validate_presence_of :address }

  describe 'email validation' do
    context 'valid address' do
      let(:attrs) { {address: 'janedoe@example.com'} }
      it { should be_valid }
    end

    context 'invalid address' do
      let(:attrs) { {address: 'janedoe at example dot com'} }
      it { should be_invalid }
    end
  end
end
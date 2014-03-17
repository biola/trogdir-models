require 'spec_helper'

describe Changeset do
  let!(:person) { create :person }

  it { should have_many :change_syncs }

  it 'is created when a person is created' do
    expect { create :person }.to change { Changeset.count }.by 1
  end

  it 'is created when a person is updated' do
    expect { person.update_attributes! first_name: 'Peasant' }.to change { Changeset.count }.by 1
  end

  [:id, :email, :photo, :phone, :address].each do |model_name|
    it "is created when embedded #{model_name} inside person is created" do
      expect { create model_name, person: person }.to change { Changeset.count }.by 1
    end

    it "is created when embedded #{model_name} inside person is updated" do
      model = create(model_name, person: person)
      expect { model.update_attributes! attributes_for(model_name) }.to change { Changeset.count }.by 1
    end

    it "is created when embedded #{model_name} inside person is deleted" do
      model = create(model_name, person: person)
      expect { model.destroy }.to change { Changeset.count }.by 1
    end
  end

  describe '#person' do

    context 'when trackable is a Person' do
      subject { person.history_tracks.first }
      its(:person) { should eql person }
    end
  end
end
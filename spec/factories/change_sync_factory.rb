FactoryGirl.define do
  factory :change_sync do
    changeset { create(:person).history_tracks.first }
    syncinator
  end
end
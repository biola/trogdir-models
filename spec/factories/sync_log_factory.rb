FactoryGirl.define do
  factory :sync_log do
    change_sync
    started_at { Time.now }
    errored_at nil
    succeeded_at nil
    action nil
    message nil
  end
end
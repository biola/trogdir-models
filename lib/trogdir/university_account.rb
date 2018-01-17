class UniversityAccount < Account
  track_history on: [:fields],
                track_create: true,
                track_update: true,
                tracker_class_name: :account_history_tracker
end

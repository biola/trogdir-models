module TrogdirModels
  # For sharing factories with apps that use the gem
  def self.load_factories
    FactoryGirl.definition_file_paths += [File.expand_path('../../spec/factories',  __FILE__)]
  end
end

# Models
require 'mongoid'
require 'request_store'
require 'mongoid_userstamp'
autoload :Account, 'trogdir/account'
autoload :AccountHistoryTracker, 'trogdir/account_history_tracker'
autoload :Address, 'trogdir/address'
autoload :Changeset, 'trogdir/changeset'
autoload :ChangeSync, 'trogdir/change_sync'
autoload :Email, 'trogdir/email'
autoload :GuestAccount, 'trogdir/guest_account'
autoload :ID, 'trogdir/id'
autoload :Person, 'trogdir/person'
autoload :Phone, 'trogdir/phone'
autoload :Photo, 'trogdir/photo'
autoload :Syncinator, 'trogdir/syncinator'
autoload :SyncLog, 'trogdir/sync_log'
autoload :UniversityAccount, 'trogdir/university_account'

# Concerns
require 'active_support/concern'
autoload :Student, 'trogdir/concerns/student'
autoload :Employee, 'trogdir/concerns/employee'

require 'active_model/validations'
require 'email_validator'
autoload :AbsoluteUriValidator, 'trogdir/validators/absolute_uri_validator'

require 'mongoid-history'
Mongoid::History.tracker_class_name = :changeset
Mongoid::History.modifier_class_name = 'Syncinator'

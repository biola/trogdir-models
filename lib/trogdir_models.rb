module TrogdirModels
  # For sharing factories with apps that use the gem
  def self.load_factories
    FactoryGirl.definition_file_paths += [File.expand_path('../../spec/factories',  __FILE__)]
  end
end

# Models
require 'mongoid'
autoload :Person, 'trogdir/person'
autoload :ID, 'trogdir/id'
autoload :Email, 'trogdir/email'
autoload :Photo, 'trogdir/photo'
autoload :Phone, 'trogdir/phone'
autoload :Address, 'trogdir/address'
autoload :Changeset, 'trogdir/changeset'
autoload :Syncinator, 'trogdir/syncinator'
autoload :ChangeSync, 'trogdir/change_sync'
autoload :SyncLog, 'trogdir/sync_log'

# Concerns
require 'active_support/concern'
autoload :Student, 'trogdir/concerns/student'
autoload :Employee, 'trogdir/concerns/employee'

require 'active_model/validations'
require 'email_validator'
autoload :AbsoluteUriValidator, 'trogdir/validators/absolute_uri_validator'

require 'mongoid-history'
Mongoid::History.tracker_class_name = :changeset

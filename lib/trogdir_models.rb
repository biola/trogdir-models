module TrogdirModels
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

# Concerns
require 'active_support/concern'
autoload :Student, 'trogdir/concerns/student'
autoload :Employee, 'trogdir/concerns/employee'

require 'active_model/validations'
autoload :EmailValidator, 'trogdir/validators/email_validator'
autoload :AbsoluteUriValidator, 'trogdir/validators/absolute_uri_validator'

require 'mongoid-history'
Mongoid::History.tracker_class_name = :changeset
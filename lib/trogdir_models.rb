module TrogdirModels
end

# Models
require 'mongoid'
autoload :Person, 'trogdir/person'
autoload :ID, 'trogdir/id'
autoload :Email, 'trogdir/email'

# Concerns
require 'active_support/concern'
autoload :Student, 'trogdir/concerns/student'
autoload :Employee, 'trogdir/concerns/employee'

require 'active_model/validations'
autoload :EmailValidator, 'trogdir/validators/email_validator'
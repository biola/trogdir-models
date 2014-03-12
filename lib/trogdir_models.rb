module TrogdirModels
end

require 'mongoid'
require 'active_support/concern'
autoload :Person, 'trogdir/person'
autoload :Student, 'trogdir/concerns/student'
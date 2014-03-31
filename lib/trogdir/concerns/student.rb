module Student
  extend ActiveSupport::Concern

  included do
    # On-Campus Residence
    field :residence, type: String
    field :floor, type: Integer
    field :wing, type: String

    # Academic
    field :majors, type: Array

    # FERPA
    field :privacy, type: Boolean
  end
end
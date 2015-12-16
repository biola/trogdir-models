module Employee
  extend ActiveSupport::Concern

  included do
    field :department, type: String
    field :title, type: String
    field :employee_type, type: Symbol
    field :full_time, type: Boolean
    field :pay_type, type: Symbol
    field :job_ct, type: Integer
  end
end

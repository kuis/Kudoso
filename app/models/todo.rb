class Todo < ActiveRecord::Base
  belongs_to :todo_template
  belongs_to :family
  has_many :todo_schedules
end

class MyTodo < ActiveRecord::Base
  belongs_to :member
  belongs_to :todo_schedule
  has_one :todo, through: :todo_schedule
end

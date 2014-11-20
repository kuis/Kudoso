class TodoTemplate < ActiveRecord::Base
  has_many :todos
  has_and_belongs_to_many :todo_groups

end

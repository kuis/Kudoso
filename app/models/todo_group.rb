class TodoGroup < ActiveRecord::Base
  has_and_belongs_to_many :todo_templates
end

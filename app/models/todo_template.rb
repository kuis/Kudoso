class TodoTemplate < ActiveRecord::Base
  has_many :todos
  has_and_belongs_to_many :todo_groups, join_table: :todo_groups_todo_templates

  def rule
    IceCube::Rule.from_yaml(schedule)
  end

  def rule=(rule)
    self.update_attribute(:schedule, IceCube::Rule.from_yaml(rule).to_yaml)
  end

  def label
    "#{name}: #{rule.to_s}"
  end
end

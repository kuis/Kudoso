class TodoTemplate < ActiveRecord::Base
  has_many :todos, dependent: :nullify
  has_and_belongs_to_many :todo_groups, join_table: :todo_groups_todo_templates

  validates_presence_of :name
  validates_uniqueness_of :name

  def rule
    IceCube::Rule.from_yaml(schedule)
  end

  def rule=(rule)
    begin
      new_rule =  IceCube::Rule.from_yaml(rule)
      self.update_attribute(:schedule,new_rule.to_yaml)
    rescue Exception => e
      self.errors.add(:rule, "was invalid, error: #{e.message}")
      new_rule = nil
    end

  end

  def label
    "#{name}: #{rule.to_s}"
  end
end

class ScheduleRrule < ActiveRecord::Base
  belongs_to :todo_schedule

  def rule
    if self.rrule.present?
      IceCube::Rule.from_yaml(self.rrule)
    else
      IceCube::Rule.new
    end

  end

  def rule=(rule)
    begin
      new_rule =  IceCube::Rule.from_yaml(rule)
      self.update_attribute(:rrule,new_rule.to_yaml)
    rescue Exception => e
      self.errors.add(:rule, "was invalid, error: #{e.message}")
      new_rule = nil
    end
  end

  def as_json(options={})
    {
        id: self.id,
        todo_schedule_id: self.todo_schedule_id,
        rule: rule.to_hash
    }
  end

end

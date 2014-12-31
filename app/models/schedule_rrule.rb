class ScheduleRrule < ActiveRecord::Base
  belongs_to :todo_schedule

  def rule
    if self.rrule.present?
      IceCube::Rule.from_yaml(self.rrule)
    else
      nil
    end

  end

  def rule=(rule)
    self.update_attribute(:rrule, IceCube::Rule.from_yaml(rule).to_yaml)
  end

end

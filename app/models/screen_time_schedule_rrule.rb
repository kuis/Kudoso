class ScreenTimeScheduleRrule < ActiveRecord::Base
  belongs_to :screen_time_schedule

  def rule
    if self.rrule.present?
      IceCube::Rule.from_yaml(self.rrule)
    else
      IceCube::Rule.new
    end

  end

  def rule=(rule)   # rule should be in YAML format
    begin
      new_rule =  IceCube::Rule.from_yaml(rule)
      self.update_attribute(:rrule,new_rule.to_yaml)
    rescue Exception => e
      self.errors.add(:rule, "was invalid, error: #{e.message}")
      new_rule = nil
    end
  end
end

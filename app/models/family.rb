class Family < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :task_templates, through: :tasks
  has_many :devices, dependent: :destroy
  has_one :screen_time_schedule
  belongs_to :primary_contact, class_name: 'User'
  has_many :family_device_categories, dependent: :destroy
  has_many :routers
  has_many :family_activity_preferences

  accepts_nested_attributes_for :members, :reject_if => :all_blank, :allow_destroy => true

  before_create { self.secure_key = SecureRandom.base64 }

  validate :validate_timezone

  def kids
    members.where('parent IS NOT true')
  end

  def as_json(options = {})
    super({except: [:mobicip_id, :mobicip_password, :mobicip_token], methods: :device_categories }.merge(options))
  end

  def device_categories
    summary = Hash.new
    family_device_categories.each do |cat|
      summary["device_category_#{cat.device_category.id}"] = { amount: cat.amount, "device_category_name" => cat.device_category.name }
    end
    summary
  end

  def long_label
    "(#{self.id}) #{self.name}"
  end

  def self.memorialize_tasks(for_date = Date.yesterday)
    for_date = for_date.end_of_day
    @families = self.includes(:members => {:task_schedules => [:my_tasks, :schedule_rrules]})
    @families.find_each do |family|
      family.kids.each do |kid|
        kid.task_schedules.each do |schedule|
          if schedule.active && schedule.start_date <= for_date && ( schedule.end_date.blank? || schedule.end_date >= for_date )
            if schedule.schedule.occurs_on?(for_date)
              my_task = MyTask.find_or_create_by(member_id: kid.id, task_schedule_id: schedule.id, due_date: for_date)
            end
          end
        end
      end
      family.update_attribute(:memorialized_date, for_date) if family.memorialized_date.blank? || family.memorialized_date < for_date
    end
  end

  def assign_template(task_template, assign_members = Array.new)
    return false if task_template.nil?
    #add to family if not already in their task list
    task = self.tasks.find {|tasks| tasks.task_template_id == task_template.id}
    unless task.present?
      task = self.tasks.build({name: task_template.name, description: task_template.description, schedule: task_template.schedule, task_template_id: task_template.id, kudos: task_template.kudos})
      task.active = true; #can't mass assign this
      task.save
      task.create_step(steps: task_template.steps)
      # add the task to each family member
    end

    assign_members.each do |i|
      unless i.blank?
        member = Member.find_by_id(i)
        # only assign it if the member is in the same family and does not already have this task
        if member.family_id == self.id && !(member.task_schedules.find {|ts| ts.task_id == task.id})
          task_schedule = member.task_schedules.build(start_date: Date.today.beginning_of_day, task_id: task.id )
          task_schedule.active = true
          task_schedule.save
          task_schedule.schedule_rrules.create(rrule: task.schedule)
        else
          logger.warn "Attempted to assigning task_template #{task_template.id} to member #{member.id} who is not part of family #{self.id} or already has it"
        end
      end
    end

    task
  end

  def remove_template(task_template, remove_members = Array.new)
    return false if task_template.nil?
    return false unless self.task_templates.include?(task_template)

    task = self.tasks.find {|tasks| tasks.task_template_id == task_template.id}
    remove_members.each do |i|
      unless i.blank?
        begin
          member = Member.find_by_id(i)
          task_schedule = member.task_schedules.find {|ts| ts.task_id == task.id}
          # only remove it if the member is in the same family and already have this task
          if member.family_id == self.id && task_schedule.present?
            task_schedule.destroy
          else
            logger.warn "Attempted to remove task_template #{task_template.id} from member #{member.id} who is not part of family #{self.id} or was not already assigned to it"
          end
        rescue
          logger.warn 'Error processing remove template'
        end

      end
    end
    task.reload
    #remove the task from the family if there are no schedules for it
    task.destroy if task.task_schedules.count == 0
    task
  end

  # returns integer of managed devices for license purposes
  def managed_device_count
    devices.select{|d| (d.managed_devices_count == 0 && d.managed)}.count
  end

  # returns an array of recommended activities based on devices in the family
  def recommended_activities
    rec = Set.new

    devices.each do |device|
      device.device_type.activity_templates.each { |activity_template| rec << activity_template } if device.device_type
    end

    rec.to_a
  end

  def create_mobicip_account
    return true if self.mobicip_id.present? && self.mobicip_password.present?
    mobicip = Mobicip.new
    result = mobicip.create_account(self)
    return result && self.mobicip_id.present? && self.mobicip_password.present?
  end

  def active?
    #TODO: Implement this
    true
  end

  def get_cost(activity_template, time=nil)
    at = self.family_activity_preferences.where(activity_template_id: activity_template.id).first || activity_template
    if time
      return (at.cost.to_f * (time/get_time_block(at).to_f)).to_i
    else
      return at.cost
    end
  end

  def get_reward(activity_template)
    at = self.family_activity_preferences.where(activity_template_id: activity_template.id).first || activity_template
    if time
      return (at.reward.to_f * (time/get_time_block(at).to_f)).to_i
    else
      return at.reward
    end
  end

  def get_time_block(activity_template)
    at = self.family_activity_preferences.where(activity_template_id: activity_template.id).first || activity_template
    return at.time_block
  end

  def get_activity_templates
    ats = []
    self.family_activity_preferences.each do |ap|
      ats << { id: ap.activity_template_id, name: ap.activity_template.name, cost: ap.cost, reward: ap.reward, preferred: ap.preferred?, restricted_by_tasks: ap.activity_template.restricted?  } unless ap.restricted?
    end
    ActivityTemplate.find_each do |act|
      ats << { id: act.id, name: act.name, cost: act.cost, reward: act.reward, preferred: false, restricted_by_tasks: act.restricted? } unless self.family_activity_preferences.where(activity_template_id: act.id).first
    end
    ats.sort_by!{ |x| x[:id] }
  end

  private

  def validate_timezone
    timezones = ActiveSupport::TimeZone.us_zones.collect{|tz| tz.name }
    errors.add(:timezone, "is not a valid US Time Zone") unless timezone.nil? || timezones.include?(timezone)
  end



end

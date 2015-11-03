class Family < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :todo_templates, through: :todos
  has_many :devices, dependent: :destroy
  has_one :screen_time_schedule
  belongs_to :primary_contact, class_name: 'User'
  has_many :family_device_categories, dependent: :destroy
  has_many :routers

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

  def self.memorialize_todos(for_date = Date.yesterday)
    for_date = for_date.end_of_day
    @families = self.includes(:members => {:todo_schedules => [:my_todos, :schedule_rrules]})
    @families.find_each do |family|
      family.kids.each do |kid|
        kid.todo_schedules.each do |schedule|
          if schedule.active && schedule.start_date <= for_date && ( schedule.end_date.blank? || schedule.end_date >= for_date )
            if schedule.schedule.occurs_on?(for_date)
              my_todo = MyTodo.find_or_create_by(member_id: kid.id, todo_schedule_id: schedule.id, due_date: for_date)
            end
          end
        end
      end
      family.update_attribute(:memorialized_date, for_date) if family.memorialized_date.blank? || family.memorialized_date < for_date
    end
  end

  def assign_template(todo_template, assign_members = Array.new)
    return false if todo_template.nil?
    #add to family if not already in their todo list
    todo = self.todos.find {|todos| todos.todo_template_id == todo_template.id}
    unless todo.present?
      todo = self.todos.build({name: todo_template.name, description: todo_template.description, schedule: todo_template.schedule, todo_template_id: todo_template.id, kudos: todo_template.kudos})
      todo.active = true; #can't mass assign this
      todo.save
      todo.create_step(steps: todo_template.steps)
      # add the todo to each family member
    end

    assign_members.each do |i|
      unless i.blank?
        member = Member.find_by_id(i)
        # only assign it if the member is in the same family and does not already have this todo
        if member.family_id == self.id && !(member.todo_schedules.find {|ts| ts.todo_id == todo.id})
          todo_schedule = member.todo_schedules.build(start_date: Date.today.beginning_of_day, todo_id: todo.id )
          todo_schedule.active = true
          todo_schedule.save
          todo_schedule.schedule_rrules.create(rrule: todo.schedule)
        else
          logger.warn "Attempted to assigning todo_template #{todo_template.id} to member #{member.id} who is not part of family #{self.id} or already has it"
        end
      end
    end

    todo
  end

  def remove_template(todo_template, remove_members = Array.new)
    return false if todo_template.nil?
    return false unless self.todo_templates.include?(todo_template)

    todo = self.todos.find {|todos| todos.todo_template_id == todo_template.id}
    remove_members.each do |i|
      unless i.blank?
        begin
          member = Member.find_by_id(i)
          todo_schedule = member.todo_schedules.find {|ts| ts.todo_id == todo.id}
          # only remove it if the member is in the same family and already have this todo
          if member.family_id == self.id && todo_schedule.present?
            todo_schedule.destroy
          else
            logger.warn "Attempted to remove todo_template #{todo_template.id} from member #{member.id} who is not part of family #{self.id} or was not already assigned to it"
          end
        rescue
          logger.warn 'Error processing remove template'
        end

      end
    end
    todo.reload
    #remove the todo from the family if there are no schedules for it
    todo.destroy if todo.todo_schedules.count == 0
    todo
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


  private

  def validate_timezone
    timezones = ActiveSupport::TimeZone.us_zones.collect{|tz| tz.name }
    errors.add(:timezone, "is not a valid US Time Zone") unless timezone.nil? || timezones.include?(timezone)
  end



end

class Member < ActiveRecord::Base
  belongs_to :family
  has_one :user, dependent: :nullify
  belongs_to :contact
  has_many :emails, through: :contact
  has_many :todo_schedules, dependent: :destroy
  has_many :my_todos, dependent: :destroy
  has_many :primary_devices, class_name: 'Device', foreign_key: 'primary_member_id', dependent: :nullify
  has_many :activities, dependent: :destroy, inverse_of: :member
  has_many :authorized_activities, class_name: 'Activity', foreign_key: :created_by_id, dependent: :nullify, inverse_of: :created_by
  has_many :screen_times
  has_many :st_overrides
  has_many :screen_time_schedules

  accepts_nested_attributes_for :contact


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :registerable, :recoverable, :validatable, :confirmable, :lockable,
  devise :database_authenticatable, :authentication_keys => [:username, :family_id]
  devise :rememberable, :trackable, :timeoutable

  validates_presence_of :username, :family

  validates :username, uniqueness: { scope: :family_id }

  # override to scope username into family_id
  def self.find_for_authentication(warden_conditions)
    where(:username => warden_conditions[:username], :family_id => warden_conditions[:family_id]).first
  end

  def first_name
    contact.try(:first_name) || ''
  end

  def last_name
    contact.try(:last_name) || ''
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def details
    self.my_todos.where('due_date >= ?', 1.month.ago).order(:due_date).reverse_order.group_by(&:due_date)
  end

  def todos(start_date = Date.today, end_date = Date.today)
    todos = []
    (start_date .. end_date).each do |date|
      local_todos = self.my_todos.where("due_date >= ? AND due_date <= ?", date.beginning_of_day, date.end_of_day).map.to_a
      logger.info "Local todos count: #{local_todos.count}"
      self.todo_schedules.where('start_date <= ? AND (end_date IS NULL OR end_date >= ?)', start_date, end_date).find_each do |ts|
        todo = local_todos.find{ |td| td.todo_schedule_id == ts.id }
        if todo.nil?
          schedule = IceCube::Schedule.new
          schedule.start_time = ts.start_date
          ts.schedule_rrules.each do |rule|
            schedule.add_recurrence_rule(IceCube::Rule.from_yaml(rule.rrule))
          end
          local_todos << self.my_todos.build(todo_schedule_id: ts.id, due_date: date ) if schedule.occurs_on?(date)
        end
      end
      todos.concat(local_todos)
    end
    todos
  end

  def todos_complete?(start_date = Date.today, end_date = Date.today)
    ret = true
    todos(start_date, end_date).each do |my_todo|
      ret = false if my_todo.todo.required? && !my_todo.complete?
    end
    ret
  end


  def get_screen_time_overrides(date = Date.today)
    st_overrides.where(date: date.beginning_of_day..date.end_of_day).sum(:time)
  end



  def get_used_screen_time(date = Date.today, device_id = nil, activity_id=nil)
    if device_id.present?
      activities.where('device_id = ? AND end_time BETWEEN ? AND ?', device_id, date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    elsif activity_id.present?
      activities.where('activity_id = ? AND end_time BETWEEN ? AND ?', activity_id, date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    else
      activities.where('end_time BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    end
  end

  def get_screen_time(date = Date.today, device_id = nil, activity_id = nil)
    rec = screen_times.where(dow: date.wday).last

    if device_id.nil? && activity_id.nil?
      result = rec.try(:default_time) || 60*60*24 # Return unlimited if not set

    else
      if rec.nil?
        result = 60*60*24
      else
        device_limit = rec.restrictions[:devices].try(:[], :device_id).try(:[],:default_time)  || rec.default_time || 60*60*24
        activity_limit = rec.restrictions[:activities].try(:[], :activity_id).try(:[],:default_time) || rec.default_time || 60*60*24
        result = ( device_limit < activity_limit ? device_limit : activity_limit)
      end

    end
    result += get_screen_time_overrides

    result = 60*60*24 if result > 60*60*24

    result
  end

  def get_max_screen_time(date = Date.today, device_id = nil, activity_id = nil)
    rec = screen_times.where(dow: date.wday).last

    if device_id.nil? && activity_id.nil?
      result = rec.try(:max_time) || 60*60*24 # Return unlimited if not set

    else
      if rec.nil?
        result = 60*60*24
      else
        device_limit = rec.restrictions[:devices].try(:[], :device_id).try(:[], :max_time)  || rec.max_time || 60*60*24
        activity_limit = rec.restrictions[:activities].try(:[], :activity_id).try(:[], :max_time) || rec.max_time || 60*60*24
        result = ( device_limit < activity_limit ? device_limit : activity_limit)
      end

    end

    result
  end

  def get_available_screen_time(date = Date.today, device_id = nil, activity_id = nil)
    (get_screen_time(date, device_id, activity_id) - get_used_screen_time(date, device_id, activity_id)).to_i
  end


  def set_screen_time!(dow, default_time, max_time, device_id = nil, activity_id = nil)
    raise 'Must set a valid Day of Week (0=Sunday .. 6=Staturday)' if dow.nil? || !(0..6).include?(dow)
    my_time = screen_times.find_or_initialize_by(dow: dow)
    if device_id.nil? && activity_id.nil?
      my_time.max_time = max_time
      my_time.default_time = default_time
    else
      my_time.max_time ||= max_time
      my_time.default_time ||= default_time
      my_time.restrictions[:devices][:device_id] = { default_time: default_time, max_time: max_time} if device_id
      my_time.restrictions[:activities][:activity_id] = { default_time: default_time, max_time: max_time} if activity_id
    end


    my_time.save
  end

  def new_activity(family_activity, device)
    # TODO: Check cost of activity before creating
    act = self.activities.create(family_activity_id: family_activity.id, device_id: device.try(:id), created_by_id: self.id)
  end

  def current_activity
    activities.where(end_time: nil).last
  end

  def can_do_activity?(family_activity, device = nil)
    #TODO: Implement device logic
    ret = false

    # Check if activity is restricted
    if family_activity.restricted?
      ret = !!get_available_screen_time if todos_complete?
    else
      ret = !!get_available_screen_time
    end

    if ret
      # Member has enough screen time, but does the schedule restrict it?

      # Check family wide restrictions
      self.family.screen_time_schedules.each do |st_sched|
        ret = false if st_sched.schedule.occurring_at?(Time.now)
      end
      # Check member specific restrictions
      self.screen_time_schedules.each do |st_sched|
        ret = false if st_sched.schedule.occurring_at?(Time.now)
      end
    end

    ret
  end
end

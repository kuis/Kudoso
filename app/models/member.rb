class Member < ActiveRecord::Base
  belongs_to :family
  has_one :user, dependent: :nullify
  has_many :todo_schedules, dependent: :destroy
  has_many :my_todos, dependent: :destroy
  has_many :primary_devices, class_name: 'Device', foreign_key: 'primary_member_id', dependent: :nullify
  has_many :activities, dependent: :destroy, inverse_of: :member
  has_many :authorized_activities, class_name: 'Activity', foreign_key: :created_by_id, dependent: :nullify, inverse_of: :created_by
  has_many :screen_times

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :omniauthable
  # :registerable, :recoverable, :validatable, :confirmable, :lockable,
  devise :database_authenticatable, :authentication_keys => [:username, :family_id]
  devise :rememberable, :trackable, :timeoutable

  validates_presence_of :first_name, :username, :family

  validates :username, uniqueness: { scope: :family_id }

  # override to scope username into family_id
  def self.find_for_authentication(warden_conditions)
    where(:username => warden_conditions[:username], :family_id => warden_conditions[:family_id]).first
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
      local_todos = self.my_todos.where('due_date = ?', date).map.to_a
      self.todo_schedules.where('start_date <= ? AND (end_date IS NULL OR end_date <= ?)', date, date).find_each do |ts|
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
    todos.each do |todo|
      ret = false unless todo.required? && todo.complete?
    end
    ret
  end





  def get_used_screen_time(date = Time.now, device_id = nil)
    if device_id.present?
      activities.where('device_id = ? AND end_time BETWEEN ? AND ?', device_id, date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    else
      activities.where('end_time BETWEEN ? AND ?', date.beginning_of_day, date.end_of_day).sum('extract(epoch from end_time - start_time)').ceil
    end
  end

  def get_max_screen_time(date = Time.now, device_id = nil)
    rec = screen_times.where(device_id: device_id, dow: date.wday).last
    if rec
      rec.maxtime
    else
      if device_id
        # if device_id was set but we didn't find a specific max for it, use the global
        rec = screen_times.where(device_id: nil, dow: date.wday).last
        if rec
          rec.maxtime
        else
          60*60*24 # Return unlimited if not set
        end
      else
        60*60*24 # Return unlimited if not set
      end
    end
  end

  def get_available_screen_time(date = Time.now, device_id = nil)
    (get_max_screen_time(date, device_id) - get_used_screen_time(date, device_id)).to_i
  end


  def set_screen_time!(dow, maxtime, device_id = nil)
    raise 'Must set a valid Day of Week (0=Sunday .. 6=Staturday)' if dow.nil? || !(0..6).include?(dow)
    my_time = screen_times.find_or_initialize_by(device_id: device_id, dow: dow)
    my_time.maxtime = maxtime
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
    ret = false
    if family_activity.restricted?
      ret = !!get_available_screen_time if todos_complete?
    else
      ret = !!get_available_screen_time
    end
    ret
  end
end

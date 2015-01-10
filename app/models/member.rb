class Member < ActiveRecord::Base
  belongs_to :family
  has_one :user, dependent: :nullify
  has_many :todo_schedules, dependent: :destroy
  has_many :my_todos, dependent: :destroy
  has_many :primary_devices, class_name: 'Device', foreign_key: 'primary_member_id', dependent: :nullify
  has_many :activities, dependent: :destroy
  has_many :authorized_activities, class_name: 'Activity', foreign_key: :created_by, dependent: :destroy

  validates_presence_of :first_name, :username

  validates :username, uniqueness: { scope: :family_id }


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
end

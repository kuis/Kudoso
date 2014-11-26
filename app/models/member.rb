class Member < ActiveRecord::Base
  belongs_to :family
  has_one :user
  has_many :todo_schedules
  has_many :my_todos

  validates_presence_of :first_name, :username

  validates :username, uniqueness: { scope: :family_id }

  def full_name
    "#{first_name} #{last_name}"
  end

  def todos(date = Date.today)
    todos = self.my_todos.where('due_date = ?', date).map.to_a
    self.todo_schedules.where('start_date <= ? AND (end_date IS NULL OR end_date <= ?)', date, date).find_each do |ts|
      todo = todos.find{ |td| td.todo_schedule_id == ts.id }
      if todo.nil?
        schedule = IceCube::Schedule.from_yaml(ts.schedule)
        todos << self.my_todos.build(todo_schedule_id: ts.id, due_date: date ) if schedule.occurs_on?(date)
      end
    end
    todos
  end
end

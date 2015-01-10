class Family < ActiveRecord::Base
  has_many :users, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :todos, dependent: :destroy
  has_many :devices, dependent: :destroy

  def kids
    members.where('parent IS NOT true')
  end

  def self.memorialize_todos(for_date = Date.yesterday)
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

  def assign_group(todo_group, assign_members = Array.new)
    todo_group.todo_templates.each do |todo_template|
      self.assign_template(todo_template, assign_members)
    end
  end

  def assign_template(todo_template, assign_members = Array.new)
    #add to family if not already in their todo list
    unless self.todos.find {|todo| todo.todo_template_id == todo_template.id}
      todo = self.todos.build({name: todo_template.name, description: todo_template.description, schedule: todo_template.schedule, todo_template_id: todo_template.id, kudos: todo_template.kudos})
      todo.active = true; #can't mass assign this
      todo.save
      # add the todo to each family member

      assign_members.each do |i|
        unless i.blank?
          member = Member.find(i)

          if member.family_id == self.id
            todo_schedule = member.todo_schedules.build(start_date: Date.today, todo_id: todo.id )
            todo_schedule.active = true
            todo_schedule.save
            todo_schedule.schedule_rrules.create(rrule: todo.schedule)
          end
        end

      end

    end
  end

end

class MyTodo < ActiveRecord::Base
  belongs_to :member
  belongs_to :todo_schedule
  has_one :todo, through: :todo_schedule

  validates_presence_of :todo_schedule
  before_save :apply_kudos

  def required?
    todo.required
  end
  private

  def apply_kudos
    if self.complete_changed? &&  self.todo.kudos.present?
      if self.complete?
        logger.debug "Adding #{self.todo.kudos} to #{self.member.full_name}"
        member.update_attribute(:kudos,(member.kudos + self.todo.kudos) )
      else
        if self.persisted? # Only deduct kudos if we had previously saved
          logger.debug "Removing #{self.todo.kudos} to #{self.member.full_name}"
          member.update_attribute(:kudos,(member.kudos - self.todo.kudos) )
        end
      end
    end
  end
end

class MyTask < ActiveRecord::Base
  belongs_to :member
  belongs_to :task_schedule
  has_one :task, through: :task_schedule
  has_one :family, through: :member

  validates_presence_of :task_schedule, :member_id, :member
  before_save :apply_kudos

  validate :due_times
  validate :my_task_schedule

  def required?
    task.required
  end

  def verify!(verified_by)
    return false unless verified_by.try(:parent) &&  verified_by.try(:family) == self.family
    self.update_attributes( { verified_by: verified_by.id, verified_at: Time.now } )
  end

  def as_json(options = {})
    super({ methods: :required?, include: { task_schedule: { include: { task: { methods: :steps } } } } }.merge(options))
  end

  private

  def my_task_schedule
    if task_schedule.member_id != member_id
      self.errors.add(:task_schedule, "does not belong to this member.")
    end
  end
  def due_times
    if due_time.present? && ( due_time.to_date != due_date.to_date )
      self.errors.add(:due_time, "must be on the same day as due date.  Due time = #{due_time.localtime}  Due date = #{due_date}")
    end
  end

  def apply_kudos
    if self.complete_changed? &&  self.task.kudos.present?
      if self.complete?
        logger.debug "Adding #{self.task.kudos} to #{self.member.full_name}"
        member.credit_kudos( self.task.kudos, "Completed Task: #{self.task.name}")
      else
        if self.persisted? # Only deduct kudos if we had previously saved
          logger.debug "Removing #{self.task.kudos} to #{self.member.full_name}"
          member.debit_kudos( self.task.kudos, "Removed Completed Task: #{self.task.name}")
        end
      end
    end
  end
end

class Todo < ActiveRecord::Base
  belongs_to :todo_template
  belongs_to :family
  has_many :todo_schedules, dependent: :destroy
  has_many :members, -> { uniq }, through: :todo_schedules

  after_initialize :init

  private

  def init
    self.active ||= true;
  end
end

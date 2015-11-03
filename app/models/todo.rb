class Todo < ActiveRecord::Base
  belongs_to :todo_template
  belongs_to :family
  has_many :todo_schedules, dependent: :destroy
  has_many :members, -> { uniq }, through: :todo_schedules
  has_one :step, as: :stepable, dependent: :destroy

  after_initialize :init

  validates_presence_of :name, :family_id, :family
  validates_uniqueness_of :name, scope: :family_id

  def steps
    step.present? ? step.steps : []
  end

  private

  def init
    self.active ||= true;
  end
end

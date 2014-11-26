class TodoSchedule < ActiveRecord::Base
  belongs_to :todo
  belongs_to :member
  has_many :my_todos

  after_initialize :init

  private

  def init
    self.start_date ||= Date.today
  end
end

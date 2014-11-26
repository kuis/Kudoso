class TodoSchedule < ActiveRecord::Base
  belongs_to :todo
  belongs_to :member
  has_many :my_todos, dependent: :destroy
  has_many :schedule_rrules, dependent: :destroy
  accepts_nested_attributes_for :schedule_rrules, :reject_if => :all_blank, :allow_destroy => true

  validate :valid_dates?

  validate :valid_start_date?, on: :create
  validate :unchanged_start_date?, on: :update

  after_initialize :init



  private

  def valid_dates?
    if start_date.blank?
      errors.add(:start_date, 'must be set')
    end
    if !end_date.blank? && end_date < start_date
      errors.add(:end_date, 'cannot be earilier than start_date')
    end
  end

  def valid_start_date?
    if start_date < Date.today
      errors.add(:start_date, 'cannot be in the past')
    end
  end

  def unchanged_start_date?
    if start_date_changed?
      errors.add(:start_date, 'cannot be changed')
    end
  end

  def init
    self.start_date ||= Date.today
  end


end

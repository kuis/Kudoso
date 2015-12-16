class TaskTemplate < ActiveRecord::Base
  include NotDeleteable

  has_many :tasks, dependent: :nullify
  has_one :step, as: :stepable, dependent: :destroy

  accepts_nested_attributes_for :step, allow_destroy: false

  validates_presence_of :name
  validates_uniqueness_of :name

  validates :rec_min_age, :rec_max_age, :def_min_age, :def_max_age, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 99, only_integer: true }, allow_blank: true

  validates_presence_of :rec_max_age, if: :rec_ages_present?
  validates_presence_of :def_max_age, if: :def_ages_present?

  validates :rec_max_age, numericality: { greater_than: :rec_min_age }, if: :rec_ages_present?
  validates :def_max_age, numericality: { greater_than: :def_min_age }, if: :def_ages_present?


  def rule
    IceCube::Rule.from_yaml(schedule)
  end

  def rule=(rule)
    begin
      new_rule =  IceCube::Rule.from_yaml(rule)
      self.update_attribute(:schedule,new_rule.to_yaml)
    rescue Exception => e
      self.errors.add(:rule, "was invalid, error: #{e.message}")
      new_rule = nil
    end

  end

  def steps
    step.present? ? step.steps : []
  end

  def label
    "#{name}: #{rule.to_s}"
  end

  private

  def rec_ages_present?
    rec_min_age.present?
  end
  def def_ages_present?
    def_min_age.present?
  end
end

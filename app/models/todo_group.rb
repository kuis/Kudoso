class TodoGroup < ActiveRecord::Base
  attr_accessor :member_ids # used for the association table in todo_groups

  has_and_belongs_to_many :todo_templates, join_table: :todo_groups_todo_templates

  accepts_nested_attributes_for :todo_templates, :reject_if => :all_blank, :allow_destroy => false

  scope :active, -> { where(active: true).order(:rec_min_age) }

  validates_presence_of :name
  validates_uniqueness_of :name

  validates :rec_min_age, :rec_max_age, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100, only_integer: true  }, allow_blank: true

end

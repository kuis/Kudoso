class TodoGroup < ActiveRecord::Base
  attr_accessor :member_ids # used for the association table in todo_groups

  has_and_belongs_to_many :todo_templates, join_table: :todo_groups_todo_templates

  accepts_nested_attributes_for :todo_templates, :reject_if => :all_blank, :allow_destroy => false

  scope :active, -> { where(active: true).order(:rec_min_age) }

end

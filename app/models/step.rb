class Step < ActiveRecord::Base
  belongs_to :stepable, polymorphic: true
  serialize :steps, Array
end

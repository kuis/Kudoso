class TodoSchedule < ActiveRecord::Base
  belongs_to :todo
  belongs_to :member
end

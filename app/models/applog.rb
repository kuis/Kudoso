class Applog < ActiveRecord::Base
  belongs_to :app
  belongs_to :device
  belongs_to :member
end

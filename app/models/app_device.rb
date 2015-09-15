class AppDevice < ActiveRecord::Base
  belongs_to :app
  belongs_to :device

  validates_presence_of :app, :device
end

class AppMember < ActiveRecord::Base
  belongs_to :app
  belongs_to :member

  validates_presence_of :app, :member
end

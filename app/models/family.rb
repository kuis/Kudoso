class Family < ActiveRecord::Base
  has_many :users
  has_many :members
  has_many :todos
end

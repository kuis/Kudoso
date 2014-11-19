class Household < ActiveRecord::Base
  has_many :users
end

class Invoice < ActiveRecord::Base
  belongs_to :user

  has_many :payments, dependent: :nullify
  # amount is in cents just like Stripe!
end

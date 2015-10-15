class Payment < ActiveRecord::Base
  belongs_to :invoice

  after_create do
    total_payments = self.invoice.payments.sum(:amount)
    if total_payments >= self.invoice.amount
      self.invoice.update_attribute(:closed_on, Time.now)
    end
  end
end

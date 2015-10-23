class StripeFirehose
  include Stripe::Callbacks

  after_stripe_event do |target, event|
    logger.debug "Stripe Target:\n#{target.inspect}\n\nStripe event: \n#{event.inspect}\n"
  end
end
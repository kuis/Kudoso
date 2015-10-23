# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

# Stripe.plan :primo do |plan|
#
#   # plan name as it will appear on credit card statements
#   plan.name = 'Acme as a service PRIMO'
#
#   # amount in cents. This is 6.99
#   plan.amount = 699
#
#   # currency to use for the plan (default 'usd')
#   plan.currency = 'usd'
#
#   # interval must be either 'week', 'month' or 'year'
#   plan.interval = 'month'
#
#   # only bill once every three months (default 1)
#   plan.interval_count = 3
#
#   # number of days before charging customer's card (default 0)
#   plan.trial_period_days = 30
# end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.

Stripe.plan :kudoso_plug do |plan|
  plan.name = 'Kudoso Additional Plug'
  plan.amount = 500
  plan.currency = 'usd'
  plan.interval = 'month'
end
Stripe.plan :plug_semi do |plan|
  plan.name = 'Kudoso Additional Plug'
  plan.amount = 3000
  plan.currency = 'usd'
  plan.interval = 'month'
  plan.interval_count = 6
end
Stripe.plan :plug_annual do |plan|
  plan.name = 'Kudoso Additional Plug'
  plan.amount = 5000
  plan.currency = 'usd'
  plan.interval = 'year'
end

Stripe.plan :guardian_monthly do |plan|
  plan.name = 'Kudoso Guardian Plan'
  plan.amount = 2999
  plan.currency = 'usd'
  plan.interval = 'month'
end
Stripe.plan :guardian_semi do |plan|
  plan.name = 'Kudoso Guardian Plan'
  plan.amount = 17994
  plan.currency = 'usd'
  plan.interval = 'month'
  plan.interval_count = 6
end
Stripe.plan :guardian_annual do |plan|
  plan.name = 'Kudoso Guardian Plan'
  plan.amount = 29999
  plan.currency = 'usd'
  plan.interval = 'year'
end

Stripe.plan :protector_monthly do |plan|
  plan.name = 'Kudoso Guardian Plan'
  plan.amount = 1999
  plan.currency = 'usd'
  plan.interval = 'month'
end
Stripe.plan :protector_semi do |plan|
  plan.name = 'Kudoso Guardian Plan'
  plan.amount = 11994
  plan.currency = 'usd'
  plan.interval = 'month'
  plan.interval_count = 6
end
Stripe.plan :protector_annual do |plan|
  plan.name = 'Kudoso Guardian Plan'
  plan.amount = 19999
  plan.currency = 'usd'
  plan.interval = 'year'
end

Stripe.plan :ohana_annual do |plan|
  plan.name = 'Kudoso Ohama Member'
  plan.amount = 14999
  plan.currency = 'usd'
  plan.interval = 'year'
end
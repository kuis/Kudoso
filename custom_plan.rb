require 'zeus/parallel_tests'

class CustomPlan < Zeus::ParallelTests::Rails
  # Your custom methods go here
  def test
    require 'simplecov'
    SimpleCov.start 'rails'

    super
  end
end


Zeus.plan = CustomPlan.new

ENV['GUARD_NOTIFY'] = 'true'
ENV['GUARD_NOTIFICATIONS'] = "---\n- :name: :terminal_notifier\n  :options: {}\n"
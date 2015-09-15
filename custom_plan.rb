require 'zeus/parallel_tests'


class CustomPlan < Zeus::ParallelTests::Rails
  # Your custom methods go heredef my_custom_command
  #  # see https://github.com/burke/zeus/blob/master/docs/ruby/modifying.md
  # end

  def cucumber_environment
    require 'cucumber/rspec/disable_option_parser'
    require 'cucumber/cli/main'
    require 'capybara/poltergeist'
    Capybara.javascript_driver = :poltergeist
    @cucumber_runtime = Cucumber::Runtime.new
  end

  def cucumber(argv=ARGV)
    cucumber_main = Cucumber::Cli::Main.new(argv.dup)
    had_failures = cucumber_main.execute!(@cucumber_runtime)
    exit_code = had_failures ? 1 : 0
    exit exit_code
  end

  def test(argv = ARGV)
    require 'simplecov'
    SimpleCov.start 'rails'
    # SimpleCov.start 'rails' if using RoR

    # require all ruby files
    # Dir["#{Rails.root}/app/**/*.rb"].each { |f| load f }

    # run the tests
    super
  end

end

Zeus.plan = CustomPlan.new


ENV['GUARD_NOTIFY'] = 'true'
ENV['GUARD_NOTIFICATIONS'] = "---\n- :name: :terminal_notifier\n  :options: {}\n"
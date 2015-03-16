# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard "cucumber", cmd: 'zeus parallel_cucumber' do
  watch(%r{^features/.+\.feature$})
  watch(%r{^features/support/.+$})          { "features" }

  watch(%r{^features/step_definitions/(.+)_steps\.rb$}) do |m|
    Dir[File.join("**/#{m[1]}.feature")][0] || "features"
  end
end

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.(css|scss|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }
end

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rsspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separetly)
#  * 'just' rspec: 'rspec'
group :spec do
  guard('rspec', all_on_start: false,
        all_after_pass: false,
        run_all: { parallel: true, parallel_cli: '-n 4' },
        cmd: 'zeus rspec',
        notification: true,
        failed_mode: :keep) do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$}) { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch("spec/spec_helper.rb") { "spec" }

    watch(%r{^app/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.slim|\.haml)$}) { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$}) { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
    watch(%r{^spec/support/(.+)\.rb$}) { "spec" }
    watch("config/routes.rb") { "spec/routing" }
    watch("app/controllers/application_controller.rb") { "spec/controllers" }

    watch(%r{^app/views/(.+)/.*\.(erb|slim|haml)$}) { |m| "spec/features/#{m[1]}_spec.rb" }
  end
end


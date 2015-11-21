require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'chronic'
require 'rexml/document'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Kudoso
  class Application < Rails::Application
    config.stripe.auto_mount = false
    config.middleware.insert_before ActionDispatch::ParamsParser, "CatchJsonParseErrors"
    config.assets.precompile += %w( vendor/modernizr )
    config.time_zone = "Mountain Time (US & Canada)"
    config.active_record.raise_in_transactional_callbacks = true

    config.middleware.insert_before 0, "Rack::Cors", :debug => true, :logger => (-> { Rails.logger }) do
      allow do
        origins '*'

        resource '/cors',
                 :headers => :any,
                 :methods => [:post],
                 :credentials => true,
                 :max_age => 0

        resource '*',
                 :headers => :any,
                 :methods => [:get, :post, :delete, :put, :patch, :options, :head],
                 :max_age => 0
      end
    end
  end
end

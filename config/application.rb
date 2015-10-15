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
  end
end

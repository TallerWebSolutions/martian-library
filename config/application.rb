# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'action_cable/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'active_job/railtie'
require 'active_model/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'active_support/core_ext'
require 'sprockets/railtie'

Bundler.require(*Rails.groups)

module MartianLibrary
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.generators do |generator|
      generator.test_framework false
      generator.stylesheets false
      generator.javascripts false
      generator.helper false
      generator.channel assets: false
    end
  end
end

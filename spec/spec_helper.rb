# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
abort('The Rails environment is running in production mode!') if Rails.env.production?
require 'rspec/rails'
require 'shoulda/matchers'

Dir[Rails.root.join('spec/support/*.rb')].each { |f| require f }

Rails.logger.level = 4

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.order = :random
  config.profile_examples = 10

  config.include FactoryBot::Syntax::Methods

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include ActiveJob::TestHelper
  config.after do
    clear_enqueued_jobs
  end

  config.before(:suite) do
    DatabaseCleaner.clean_with(:transaction)
  end

  config.before do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
    DatabaseCleaner.clean
  end

  config.after do
    DatabaseCleaner.clean
  end


  config.after(:all) do
    FileUtils.rm_rf(Dir[Rails.root.join('public/uploads/tmp/*')]) if Rails.env.test?
  end
end

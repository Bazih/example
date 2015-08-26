require 'rails_helper'

RSpec.configure do |config|

  # Capybara.server_port = 3100
  # Capybara.server_host = '0.0.0.0'

  Capybara.default_wait_time = 5
  Capybara.javascript_driver = :webkit

  config.include AcceptanceMacros, type: :feature
  config.include SphinxHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    # Ensure sphinx directories exist for the test environment
    ThinkingSphinx::Test.init
    # Configure and start Sphinx, and automatically
    # stop Sphinx at the end of the test suite.
    ThinkingSphinx::Test.start_with_autostop
  end

  config.before(:each) do
    # page.driver.allow_url('0.0.0.0')
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, sphinx: true) do
    # Sphinx Index data when running an acceptance spec.
    DatabaseCleaner.strategy = :truncation
    index
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:all) do
    FileUtils.rm_rf(Dir["#{Rails.root}/public/uploads"]) if Rails.env.test?
  end
end
require 'rails_helper'

RSpec.configure do |config|

  Capybara.server_port = 3100
  Capybara.server_host = '0.0.0.0'

  Capybara.default_wait_time = 5
  Capybara.javascript_driver = :webkit

  config.include AcceptanceMacros, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
    # page.driver.allow_url("0.0.0.0")
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
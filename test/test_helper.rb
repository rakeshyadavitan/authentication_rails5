ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def generate_unique_email
    @@email_count ||= 0
    @@email_count += 1
    "test#{@@email_count}@example.com"
  end
  
  def valid_user_attributes(attributes={})
    { name: "usertest",
      email: generate_unique_email,
      password: '12345678',
      password_confirmation: '12345678' }.update(attributes)
  end

  def assert_and_follow_redirect!
    assert_response :redirect
    follow_redirect!
  end
  
end

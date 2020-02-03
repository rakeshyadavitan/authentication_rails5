require 'test_helper'

class UserSignUpFlowsTest < ActionDispatch::IntegrationTest

  test "a new user is able to successfully signup for the site" do
    user = valid_user_attributes
    # 1. user visits the signup page and submits the form
    get '/registrations/new'
    assert_response :success
    assert_emails 1 do
      post "/registrations", params: { user: user }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_response :success
    assert_select 'div#notice', "Check your email with subject 'Confirmation instructions'"
    # 2. user attempts to login without confirming
    post '/sessions', params: { email: user[:email], password: user[:password] }
    assert_response :success
    assert_select 'div#alert', "Email or password is invalid"
    # 3. user gets email and clicks the confirmation link
    db_user = User.find_by(email: user[:email])
    get "/confirmations/#{db_user.id}?confirmation_token=#{db_user.confirmation_token}"
    assert_and_follow_redirect!
    assert_response :success
    assert_select 'div#notice', "You are confirmed! You can now login."
    # 4. user can login now
    post '/sessions', params: { email: user[:email], password: user[:password] }
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'div#notice', "Logged in!"
  end

  test "if confirmation link expires, user is not confirmed" do
    user = users(:one)
    user.update(confirmation_token: 'blah', confirmation_sent_at: 1.hours.ago)
    get "/confirmations/#{user.id}?confirmation_token=#{user.confirmation_token}"
    assert_redirected_to new_registration_url
    follow_redirect!
    assert_response :success
    assert_select 'div#alert', "Confirmation token has expired. Signup again."
  end
end

require 'test_helper'

class UserSignUpFlowsTest < ActionDispatch::IntegrationTest

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

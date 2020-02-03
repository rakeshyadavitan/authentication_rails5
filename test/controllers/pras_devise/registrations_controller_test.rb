require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest

  test "user can attempt to signup again after confirmation token has expired" do
    user = user(:one)
    # 1. user visits the signup page and submits the form
    assert_emails 1 do
      post "/registrations", params: { user: user }
    end
  end

end

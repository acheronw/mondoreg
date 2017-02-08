require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "Invalid signup information" do
    get signup_path # This is actually not required
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: "",
                                         email: "user@invalid",
                                         password: "123",
                                         password_confirmation: "1234" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
    assert_select 'form[action="/signup"]'
  end

  test "Valid signup" do

    assert_difference 'User.count', 1 do
      get signup_path # This is actually not required
      post users_path, params: { user: { name: "Teszt Béla",
                                         email: "bela@teszt.com",
                                         password: "12345678",
                                         password_confirmation: "12345678" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_select 'div.alert-success'

  end

end

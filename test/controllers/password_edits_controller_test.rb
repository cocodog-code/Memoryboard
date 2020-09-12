require 'test_helper'

class PasswordEditsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get password_edits_edit_url
    assert_response :success
  end

end

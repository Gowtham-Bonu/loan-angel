require "test_helper"

class LoanControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get loan_show_url
    assert_response :success
  end
end

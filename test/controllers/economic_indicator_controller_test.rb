require 'test_helper'

class EconomicIndicatorControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get economic_indicator_index_url
    assert_response :success
  end

end

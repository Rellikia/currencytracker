require 'test_helper'

class V1::CurrenciesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get v1_currencies_index_url
    assert_response :success
  end

end

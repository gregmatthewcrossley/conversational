require "test_helper"

class ControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ = (:one)
  end

  test "should get index" do
    get _url
    assert_response :success
  end

  test "should get new" do
    get new__url
    assert_response :success
  end

  test "should create " do
    assert_difference(".count") do
      post _url, params: { : { details: @.details, location_id: @.location_id, title: @.title } }
    end

    assert_redirected_to _url(.last)
  end

  test "should show " do
    get _url(@)
    assert_response :success
  end

  test "should get edit" do
    get edit__url(@)
    assert_response :success
  end

  test "should update " do
    patch _url(@), params: { : { details: @.details, location_id: @.location_id, title: @.title } }
    assert_redirected_to _url(@)
  end

  test "should destroy " do
    assert_difference(".count", -1) do
      delete _url(@)
    end

    assert_redirected_to _url
  end
end

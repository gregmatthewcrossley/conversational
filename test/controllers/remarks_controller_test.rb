require "test_helper"

class RemarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @remark = remarks(:one)
  end

  test "should get index" do
    get remarks_url
    assert_response :success
  end

  test "should get new" do
    get new_remark_url
    assert_response :success
  end

  test "should create remark" do
    assert_difference("Remark.count") do
      post remarks_url, params: { remark: {  } }
    end

    assert_redirected_to remark_url(Remark.last)
  end

  test "should show remark" do
    get remark_url(@remark)
    assert_response :success
  end

  test "should get edit" do
    get edit_remark_url(@remark)
    assert_response :success
  end

  test "should update remark" do
    patch remark_url(@remark), params: { remark: {  } }
    assert_redirected_to remark_url(@remark)
  end

  test "should destroy remark" do
    assert_difference("Remark.count", -1) do
      delete remark_url(@remark)
    end

    assert_redirected_to remarks_url
  end
end

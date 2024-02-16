require "application_system_test_case"

class RemarksTest < ApplicationSystemTestCase
  setup do
    @remark = remarks(:one)
  end

  test "visiting the index" do
    visit remarks_url
    assert_selector "h1", text: "Remarks"
  end

  test "should create remark" do
    visit remarks_url
    click_on "New remark"

    click_on "Create Remark"

    assert_text "Remark was successfully created"
    click_on "Back"
  end

  test "should update Remark" do
    visit remark_url(@remark)
    click_on "Edit this remark", match: :first

    click_on "Update Remark"

    assert_text "Remark was successfully updated"
    click_on "Back"
  end

  test "should destroy Remark" do
    visit remark_url(@remark)
    click_on "Destroy this remark", match: :first

    assert_text "Remark was successfully destroyed"
  end
end

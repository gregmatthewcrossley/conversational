require "application_system_test_case"

class Test < ApplicationSystemTestCase
  setup do
    @ = (:one)
  end

  test "visiting the index" do
    visit _url
    assert_selector "h1", text: ""
  end

  test "should create " do
    visit _url
    click_on "New "

    fill_in "Details", with: @.details
    fill_in "Location", with: @.location_id
    fill_in "Title", with: @.title
    click_on "Create "

    assert_text " was successfully created"
    click_on "Back"
  end

  test "should update " do
    visit _url(@)
    click_on "Edit this ", match: :first

    fill_in "Details", with: @.details
    fill_in "Location", with: @.location_id
    fill_in "Title", with: @.title
    click_on "Update "

    assert_text " was successfully updated"
    click_on "Back"
  end

  test "should destroy " do
    visit _url(@)
    click_on "Destroy this ", match: :first

    assert_text " was successfully destroyed"
  end
end

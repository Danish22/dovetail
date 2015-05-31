require 'test_helper'

class MeetingroomsControllerTest < ActionController::TestCase
  setup do
    @meetingroom = meetingrooms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:meetingrooms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create meetingroom" do
    assert_difference('Meetingroom.count') do
      post :create, meetingroom: { description: @meetingroom.description, location_id: @meetingroom.location_id, name: @meetingroom.name, space_id: @meetingroom.space_id, user__id: @meetingroom.user__id }
    end

    assert_redirected_to meetingroom_path(assigns(:meetingroom))
  end

  test "should show meetingroom" do
    get :show, id: @meetingroom
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @meetingroom
    assert_response :success
  end

  test "should update meetingroom" do
    patch :update, id: @meetingroom, meetingroom: { description: @meetingroom.description, location_id: @meetingroom.location_id, name: @meetingroom.name, space_id: @meetingroom.space_id, user__id: @meetingroom.user__id }
    assert_redirected_to meetingroom_path(assigns(:meetingroom))
  end

  test "should destroy meetingroom" do
    assert_difference('Meetingroom.count', -1) do
      delete :destroy, id: @meetingroom
    end

    assert_redirected_to meetingrooms_path
  end
end

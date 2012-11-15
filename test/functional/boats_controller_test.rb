require 'test_helper'

class BoatsControllerTest < ActionController::TestCase
  setup do
    @boat = boats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:boats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create boat" do
    assert_difference('Boat.count') do
      post :create, boat: { hull_id: @boat.hull_id, name: @boat.name, usage_id: @boat.usage_id, weight_id: @boat.weight_id }
    end

    assert_redirected_to boat_path(assigns(:boat))
  end

  test "should show boat" do
    get :show, id: @boat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @boat
    assert_response :success
  end

  test "should update boat" do
    put :update, id: @boat, boat: { hull_id: @boat.hull_id, name: @boat.name, usage_id: @boat.usage_id, weight_id: @boat.weight_id }
    assert_redirected_to boat_path(assigns(:boat))
  end

  test "should destroy boat" do
    assert_difference('Boat.count', -1) do
      delete :destroy, id: @boat
    end

    assert_redirected_to boats_path
  end
end

require 'test_helper'

class HullsControllerTest < ActionController::TestCase
  setup do
    @hull = hulls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hulls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hull" do
    assert_difference('Hull.count') do
      post :create, hull: { category_id: @hull.category_id, name: @hull.name, seats: @hull.seats }
    end

    assert_redirected_to hull_path(assigns(:hull))
  end

  test "should show hull" do
    get :show, id: @hull
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @hull
    assert_response :success
  end

  test "should update hull" do
    put :update, id: @hull, hull: { category_id: @hull.category_id, name: @hull.name, seats: @hull.seats }
    assert_redirected_to hull_path(assigns(:hull))
  end

  test "should destroy hull" do
    assert_difference('Hull.count', -1) do
      delete :destroy, id: @hull
    end

    assert_redirected_to hulls_path
  end
end

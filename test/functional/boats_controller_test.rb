require File.dirname(__FILE__) + '/../test_helper'
require 'boats_controller'

# Re-raise errors caught by the controller.
class BoatsController; def rescue_action(e) raise e end; end

class BoatsControllerTest < Test::Unit::TestCase
  fixtures :boats

  def setup
    @controller = BoatsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = boats(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:boats)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:boat)
    assert assigns(:boat).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:boat)
  end

  def test_create
    num_boats = Boat.count

    post :create, :boat => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_boats + 1, Boat.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:boat)
    assert assigns(:boat).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Boat.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Boat.find(@first_id)
    }
  end
end

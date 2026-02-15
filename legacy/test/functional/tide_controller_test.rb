require File.dirname(__FILE__) + '/../test_helper'
require 'tide_controller'

# Re-raise errors caught by the controller.
class TideController; def rescue_action(e) raise e end; end

class TideControllerTest < Test::Unit::TestCase
  def setup
    @controller = TideController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end

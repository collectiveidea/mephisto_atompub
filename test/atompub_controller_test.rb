require File.dirname(__FILE__) + '/test_helper'

class AtompubController < ApplicationController
  def rescue_action(e); raise e; end
end

class AtompubControllerTest < Test::Unit::TestCase
  def setup
    @controller = AtompubController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_controller_is_available
    assert_not_nil @controller
    assert_not_nil @request
    assert_not_nil @response
  end
  
  def test_servicedoc
    get :servicedoc
    assert_response :success
    assert_template 'servicedoc'
  end

  def test_index_template
    get :index, :sections => []
    assert_response :success
    assert_template 'index'
  end
  
  def test_create
    post :create, :sections => []
  end
  
end
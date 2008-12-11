require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'atompub_controller'

class AtompubController < ApplicationController
  def rescue_action(e); raise e; end
end

class AtompubControllerTest < Test::Unit::TestCase
  fixtures :users, :sites, :sections
  
  def setup
    @controller = AtompubController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
    authorize_as :quentin
  end
  
  def test_servicedoc
    get :servicedoc
    assert_response :success
    assert_template 'servicedoc'
  end

  def test_index_template
    Article.update_all(['published_at = ?', Time.now])
    get :index, :sections => []
    assert_response :success
    assert_template 'index'
  end
  
  def test_create
    @request.env['RAW_POST_DATA'] = File.read(File.dirname(__FILE__) + '/../fixtures/entry.atom')
    post :create, :sections => ['about']
    assert_response 201
    # assert_equal '', @response.headers['Location']
  end
  
end
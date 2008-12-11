require File.expand_path(File.dirname(__FILE__) + '/../test_helper')
require 'atompub_controller'

class AtompubController < ApplicationController
  def rescue_action(e); raise e; end
end

class AtompubControllerTest < Test::Unit::TestCase
  fixtures :users, :sites, :sections, :contents
  
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
    assert_xpath '/app:service/app:workspace/atom:title/[.="Mephisto"]'
  end
  
  def test_categories
    contents(:welcome).update_attribute :tag, "foo, bar, baz"
    get :categories
    assert_response :success
    assert_equal 'application/atomcat+xml', @response.content_type
    assert_xpath '/app:categories/atom:category[@term="foo"]'
    assert_xpath '/app:categories/atom:category[@term="bar"]'
    assert_xpath '/app:categories/atom:category[@term="baz"]'
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
    assert_equal 'application/atom+xml', @response.content_type
  end
  
end
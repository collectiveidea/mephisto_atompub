require File.dirname(__FILE__) + '/../test_helper'

class AtompubTest < ActionController::IntegrationTest
  fixtures :users, :sections, :sites
  
  def test_visitor_can_access_service_doc
    visitor = visit
    visitor.get servicedoc_path
    visitor.assert_response :success
    visitor.assert_equal 'application/atomsvc+xml', visitor.response.content_type
  end

  def test_visitor_can_access_index
    visitor = visit
    visitor.get collection_path
    visitor.assert_response :success
    visitor.assert_equal 'application/atom+xml', visitor.response.content_type
  end
  
  def test_visitor_cannot_create
    visitor = visit
    visitor.post collection_path
    visitor.assert_response 401
  end
  
  def test_create
    user = visit
    user.post collection_path, fixture_data('entry.atom'), basic_auth_for(:quentin)
    user.assert_response 201
    user.assert_equal 'application/atom+xml', user.response.content_type
    
    user.get user.response.headers['Location'], {}, basic_auth_for(:quentin)
    user.assert_response :success
    user.assert_equal 'application/atom+xml', user.response.content_type
  end
  
private

  def fixture_data(file)
    File.read(File.dirname(__FILE__) + "/../fixtures/#{file}")
  end
  
end
require File.dirname(__FILE__) + '/../test_helper'

class AtompubTest < ActionController::IntegrationTest
  fixtures :users, :sections, :sites, :contents
  
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
    # assert_atom_equal('entry.atom', user.response.body)
    
    user.get user.response.headers['Location'], {}, basic_auth_for(:quentin)
    user.assert_response :success
    user.assert_equal 'application/atom+xml', user.response.content_type
  end
  
  def test_show
    user = visit
    user.get collection_entry_path(contents(:welcome)), {}, basic_auth_for(:quentin)
    user.assert_response :success
    user.assert_equal 'application/atom+xml', user.response.content_type
  end
  
  def test_update
    user = visit
    user.put collection_entry_path(contents(:welcome)), {}, basic_auth_for(:quentin)
    user.assert_response :success
    user.assert_equal 'application/atom+xml', user.response.content_type
  end

  def test_destroy
    user = visit
    user.delete collection_entry_path(contents(:welcome)), {}, basic_auth_for(:quentin)
    user.assert_response :success
  end
  
  def test_categories
    user = visit
    user.get categories_path
    user.assert_response :success
    user.assert_equal 'application/atomcat+xml', user.response.content_type
  end
  
private

  def assert_atom_equal(file, xml)
    expected_entry = Atom::Entry.parse(fixture_data(file))
    actual_entry = Atom::Entry.parse(xml)
    
    assert_equal expected_entry.title.to_s, actual_entry.title.to_s
    # assert_equal expected_entry.content.to_s.strip, actual_entry.content.to_s.strip
    assert_equal expected_entry.categories, actual_entry.categories
  end

  def fixture_data(file)
    File.read(File.dirname(__FILE__) + "/../fixtures/#{file}")
  end
  
end
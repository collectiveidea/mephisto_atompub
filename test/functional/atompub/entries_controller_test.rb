require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Atompub::EntriesControllerTest < ActionController::TestCase
  fixtures :users, :sites, :sections, :contents, :assigned_sections
  
  def setup
    authorize_as :quentin
  end
  
  test "servicedoc" do
    get :servicedoc
    assert_response :success
    assert_template 'servicedoc'
    assert_xpath '/app:service/app:workspace/atom:title/[.="Mephisto"]'
  end
  
  test "categories" do
    contents(:welcome).update_attribute :tag, "foo, bar, baz"
    get :categories
    assert_response :success
    assert_equal 'application/atomcat+xml', @response.content_type
    assert_xpath '/app:categories/atom:category[@term="foo"]'
    assert_xpath '/app:categories/atom:category[@term="bar"]'
    assert_xpath '/app:categories/atom:category[@term="baz"]'
  end

  test "index" do
    Article.update_all(['published_at = ?', Time.now])
    get :index, :sections => []
    assert_response :success
    assert_template 'index'
    assert_equal 'application/atom+xml', @response.content_type
    
    assert !assigns(:articles).empty?
    assigns(:articles).each do |article|
      assert_xpath %(/feed/entry/link[@rel="edit"][@type="application/atom+xml;type=entry"][@href="#{collection_entry_url(article)}"])
      assert_xpath %(/feed/entry/app:edited[.="#{article.updated_at.xmlschema}"])
    end
  end
  
  test "create" do
    @request.env['RAW_POST_DATA'] = File.read(File.dirname(__FILE__) + '/../../fixtures/entry.atom')
    post :create, :sections => ['about']
    assert_response 201
    assert_equal 'application/atom+xml', @response.content_type
  end
  
  test "show" do
    get :show, :id => contents(:welcome)
    assert_response :success
    assert_equal 'application/atom+xml', @response.content_type
  end
  
  test "update" do
    put :update, :id => contents(:welcome)
    assert_response :success
    assert_equal 'application/atom+xml', @response.content_type
  end

  test "destroy" do
    delete :destroy, :id => contents(:welcome)
    assert_response :success
    assert !Article.exists?(contents(:welcome).id)
  end
  
end
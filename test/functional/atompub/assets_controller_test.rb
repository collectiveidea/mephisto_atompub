require File.expand_path(File.dirname(__FILE__) + '/../../test_helper')

class Atompub::AssetsControllerTest < ActionController::TestCase
  fixtures :users, :sites, :sections, :assets
  
  def setup
    authorize_as :quentin
  end

  test "index" do
    get :index
    assert_response :ok
    assert_template 'index'
    assert_equal 'application/atom+xml', @response.content_type
  end

  test "create" do
    @request.env['RAW_POST_DATA'] = File.read("#{RAILS_ROOT}/test/fixtures/assets/logo.png")
    @request.env['CONTENT_TYPE'] = 'image/png'
    @request.env['CONTENT_LENGTH'] = @request.env['RAW_POST_DATA'].length
    @request.env['Slug'] = 'suggested-slug'
    
    post :create
    
    assert_response 201
    assert_equal 'application/atom+xml;type=entry;charset=utf-8', @response.headers['type']
    assert_equal atompub_asset_url(assigns(:asset)), @response.headers['Location']
    
    assert_xpath %(id)
    assert_xpath %(title)
    assert_xpath %(author/name[.="quentin"])
    assert_xpath %(content[@type="image/png"][@src="#{assigns(:asset).public_filename}"])
    assert_xpath %(link[@rel="edit-media"][@href="#{formatted_atompub_asset_url(assigns(:asset), :format => 'atom')}"])
    assert_xpath %(link[@rel="edit"][@href="#{atompub_asset_url(assigns(:asset))}"])
  end
  
  test "show redirects to asset" do
    get :show, :id => assets(:png).id
    
    assert_redirected_to assets(:png).public_filename
  end
  
  test "show.atom" do
    get :show, :id => assets(:png).id, :format => 'atom'
    assert_response :ok
    assert_equal 'application/atom+xml', @response.content_type
  end
  
  test "update" do
    @request.env['RAW_POST_DATA'] = File.read("#{RAILS_ROOT}/test/fixtures/assets/logo.png")
    @request.env['CONTENT_TYPE'] = 'image/png'
    @request.env['CONTENT_LENGTH'] = @request.env['RAW_POST_DATA'].length
    
    old_filename = assets(:png).filename

    put :update, :id => assets(:png).id
    assert_response :ok

    assets(:png).reload
    assert_equal old_filename, assets(:png).filename
  end
  
  test "update.atom" do
    @request.env['RAW_POST_DATA'] = File.read(File.dirname(__FILE__) + '/../../fixtures/asset.atom')

    put :update, :id => assets(:png).id, :format => 'atom'
    assert_response :ok

    assets(:png).reload
    assert_equal 'The Beach', assets(:png).title
    assert_equal 1, assets(:png).tags.size
    assert_equal 'duck', assets(:png).tags.first.name
  end
  
end
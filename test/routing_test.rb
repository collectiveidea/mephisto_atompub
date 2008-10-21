require File.dirname(__FILE__) + '/test_helper'

class RoutingTest < Test::Unit::TestCase
  def test_servicedoc
    options = {:controller => 'atompub', :action => 'servicedoc'}
    assert_generates '/servicedoc', options
    assert_recognizes options, {:path => '/servicedoc', :method => 'get'}
  end

  def test_collection_without_section
    options = {:controller => 'atompub', :action => 'index', :sections => []}
    assert_generates '/collection', options
    assert_recognizes options, '/collection'
  end

  def test_collection
    options = {:controller => 'atompub', :action => 'index', :sections => ['foo']}
    assert_generates '/collection/foo', options
    assert_recognizes options, '/collection/foo'
  end
  
  def test_show
    options = {:controller => 'atompub', :action => 'show', :id => 3, :sections => ['foo']}
    assert_generates '/collection/foo/3', options
    assert_recognizes options, {:path => '/collection/foo/3', :method => 'get'}
  end

  def test_create
    options = {:controller => 'atompub', :action => 'create', :sections => ['foo']}
    assert_generates '/collection/foo', options
    assert_recognizes options, {:path => '/collection/foo', :method => 'post'}
  end

  def test_update
    options = {:controller => 'atompub', :action => 'update', :sections => ['foo']}
    assert_generates '/collection/foo', options
    assert_recognizes options, {:path => '/collection/foo', :method => 'put'}
  end

  def test_destroy
    options = {:controller => 'atompub', :action => 'destroy', :sections => ['foo']}
    assert_generates '/collection/foo', options
    assert_recognizes options, {:path => '/collection/foo', :method => 'delete'}
  end
end
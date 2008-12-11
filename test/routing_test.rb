require File.dirname(__FILE__) + '/test_helper'

class RoutingTest < ActiveSupport::TestCase
  
  test "servicedoc" do
    options = {:controller => 'atompub/entries', :action => 'servicedoc'}
    assert_generates '/servicedoc', options
    assert_recognizes options, {:path => '/servicedoc', :method => 'get'}
  end

  test "collection without section" do
    options = {:controller => 'atompub/entries', :action => 'index', :sections => []}
    assert_generates '/collection', options
    assert_recognizes options, '/collection'
  end

  test "collection with section" do
    options = {:controller => 'atompub/entries', :action => 'index', :sections => ['foo']}
    assert_generates '/collection/foo', options
    assert_recognizes options, '/collection/foo'
  end
  
  test "show" do
    options = {:controller => 'atompub/entries', :action => 'show', :id => '3'}
    assert_generates '/collection/3', options
    assert_recognizes options, {:path => '/collection/3', :method => 'get'}
  end

  test "create" do
    options = {:controller => 'atompub/entries', :action => 'create', :sections => ['foo']}
    assert_generates '/collection/foo', options
    assert_recognizes options, {:path => '/collection/foo', :method => 'post'}
  end

  test "update" do
    options = {:controller => 'atompub/entries', :action => 'update', :id => '3'}
    assert_generates '/collection/3', options
    assert_recognizes options, {:path => '/collection/3', :method => 'put'}
  end

  test "destroy" do
    options = {:controller => 'atompub/entries', :action => 'destroy', :id => '3'}
    assert_generates '/collection/3', options
    assert_recognizes options, {:path => '/collection/3', :method => 'delete'}
  end
end
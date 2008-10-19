map.with_options :controller => 'atompub' do |m|
  m.servicedoc 'servicedoc', :action => 'servicedoc', :conditions => { :method => :get }
  m.collection 'collection/*sections', :action => 'index', :conditions => { :method => :get }
  m.connect 'collection/*sections', :action => 'create', :conditions => { :method => :post }
  m.connect 'collection/*sections', :action => 'update', :conditions => { :method => :put }
  m.connect 'collection/*sections', :action => 'destroy', :conditions => { :method => :delete }
end

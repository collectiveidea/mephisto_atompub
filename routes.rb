map.with_options :controller => 'atompub' do |m|
  m.categories 'categories', :action => 'categories', :conditions => { :method => :get }
  m.servicedoc 'servicedoc', :action => 'servicedoc', :conditions => { :method => :get }
  m.with_options :requirements => {:id => /\d+/} do |member|
    member.collection_entry 'collection/:id', :action => 'show', :conditions => { :method => :get }
    member.connect 'collection/:id', :action => 'update', :conditions => { :method => :put }
    member.connect 'collection/:id', :action => 'destroy', :conditions => { :method => :delete }
  end
  m.collection 'collection/*sections', :action => 'index', :conditions => { :method => :get }
  m.connect 'collection/*sections', :action => 'create', :conditions => { :method => :post }
end

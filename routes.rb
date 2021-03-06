map.with_options :controller => 'atompub/entries' do |m|
  m.categories 'categories', :action => 'categories', :conditions => { :method => :get }
  m.service 'service', :action => 'service', :conditions => { :method => :get }
  m.with_options :requirements => {:id => /\d+/} do |member|
    member.collection_entry 'collection/:id', :action => 'show', :conditions => { :method => :get }
    member.connect 'collection/:id', :action => 'update', :conditions => { :method => :put }
    member.connect 'collection/:id', :action => 'destroy', :conditions => { :method => :delete }
  end
  m.collection 'collection/*sections', :action => 'index', :conditions => { :method => :get }
  m.connect 'collection/*sections', :action => 'create', :conditions => { :method => :post }
end

map.resources :assets, :controller => 'atompub/assets', :path_prefix => 'atompub', :name_prefix => 'atompub_'

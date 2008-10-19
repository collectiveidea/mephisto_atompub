map.with_options :controller => 'atompub' do |m|
  m.servicedoc 'servicedoc/*sections', :action => 'servicedoc', :conditions => { :method => :get}
  m.collection 'collection/*sections', :action => 'index', :conditions => { :method => :get}
  m.add_entry_to_collection 'collection/*sections', :action => 'add_entry_to_collection', :conditions => { :method => :post}
  m.edit_entry_in_collection 'collection/*sections', :action => 'edit_entry_in_collection', :conditions => { :method => :put}
  m.delete_entry_from_collection 'collection/*sections', :action => 'delete_entry_from_collection', :conditions => { :method => :delete}
end

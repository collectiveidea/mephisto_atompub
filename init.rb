#option :site_uri, 'http://www.example.com'

code_paths.each do |path|
  ActiveSupport::Dependencies.load_once_paths.delete(File.dirname(__FILE__) + "/#{path}")
end
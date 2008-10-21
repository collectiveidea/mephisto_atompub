ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../test/test_helper")
require 'test_help'

class ActionController::Integration::Session
  def basic_auth_for(login)
    {'authorization' => "Basic #{Base64.encode64("#{login}:test")}"}
  end
end

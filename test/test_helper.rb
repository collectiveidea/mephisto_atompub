ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../../../../test/test_helper")
require 'test_help'

class ActionController::Integration::Session
  def basic_auth_for(login)
    {'authorization' => "Basic #{Base64.encode64("#{login}:test")}"}
  end
end

class Test::Unit::TestCase

  def assert_xpath(query, content = nil)
    content ||= @response.body if @response
    document = rexml_document_from(content)
    assert !REXML::XPath.match(document, query).empty?, "Could not find XPath #{query} in:\n #{content}"
  end

private

  def rexml_document_from(content)
    REXML::Document.new(content).root
  rescue REXML::ParseException => e
    if e.message.include?("second root element")
      REXML::Document.new("<fake-root-element>#{stringlike}</fake-root-element>").root
    else
      raise e
    end
  end

end
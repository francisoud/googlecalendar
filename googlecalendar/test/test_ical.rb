require File.dirname(__FILE__) + '/test_helper.rb'

class ICALParserTest < Test::Unit::TestCase
  def test_parse
    parser = ICALParser.new
    path = File.dirname(__FILE__) + '/ical_sample.ics'
    calendar = parser.parse(File.read(path))
    assert_equal '2.0', calendar.version
    #assert_equal '', calendar.scale
    assert_equal 'PUBLISH', calendar.method
    
    events = calendar.events
    assert_equal 1, events.size
    
    e_test_multiline_description = events.find {|e| e.summary = "test_multiline_description"}
    assert_equal "Test: multiline description", e_test_multiline_description.description
  end
end

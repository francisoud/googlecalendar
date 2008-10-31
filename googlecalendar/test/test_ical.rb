require File.dirname(__FILE__) + '/test_helper.rb'

class ICALParserTest < Test::Unit::TestCase
  def test_parse
    parser = ICALParser.new
    path = File.dirname(__FILE__) + '/ical_sample.ics'
    File.open(path, 'r') do |f|
      calendar = parser.parse(f.read)
      assert_equal '2.0', calendar.version
      assert_equal '', calendar.scale
      assert_equal '', calendar.method
      assert_equal '', calendar.product_id
      # events = calendar.events
    end
  end
end

require 'lib/googlecalendar.rb'

class RecurrentTest < Test::Unit::TestCase
  def test_rrule_as_hash
    e = Event.new
    e.rrule = 'FREQ=WEEKLY;BYDAY=MO;WKST=MO'
    values = e.rrule_as_hash
    assert_equal 'WEEKLY', values['FREQ']
    assert_equal 'MO', values['BYDAY']
    assert_equal 'MO', values['WKST']
  end
end
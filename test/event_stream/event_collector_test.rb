require_relative '../test_helper'

class EventCollectorTest < Minitest::Should::TestCase

  def sample_event
    EventStream::Event.new(name: :test, a: 1)
  end

  teardown do
    EventCollector.clear_all
  end

  context 'an event collector' do

    should 'add to default collector' do
      EventCollector << sample_event
      assert_equal :test, EventCollector.default[0].name
    end

    should 'be empty by default' do
      assert EventCollector.default.list.empty?
    end

    should 'can be auto created' do
      EventCollector[:test_collector] << sample_event
      assert_equal :test, EventCollector[:test_collector][0].name
    end

  end

end
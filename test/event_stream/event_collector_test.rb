require_relative '../test_helper'

class EventCollectorTest < Minitest::Should::TestCase

  def sample_event
    EventStream::Event.new(name: :test, a: 1)
  end

  teardown do
    EventCollector.default_collector.clear
  end

  context 'an event collector' do

    should 'add to default collector' do
      EventCollector << sample_event
      assert_equal :test, EventCollector.default[0].name
    end

    should 'be empty by default' do
      assert EventCollector.default.list.empty?
    end

  end

end
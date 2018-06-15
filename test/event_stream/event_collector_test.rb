require_relative '../test_helper'

class EventCollectorTest < Minitest::Test

  describe 'an event collector' do

    def sample_event
      EventStream::Event.new(tags: [:test, :me], a: 1)
    end

    def before
      EventCollector.clear_all
    end

    it 'add to default collector' do
      EventCollector << sample_event
      assert_equal 'me_test', EventCollector.default[0].name
    end

    it 'can be auto created' do
      EventCollector[:test_collector] << sample_event
      assert_equal 'me_test', EventCollector[:test_collector][0].name
    end

  end

end

require_relative '../test_helper'
require 'event_stream/test_helper'

module EventStream
  class TestHelperTest < Minitest::Test

    describe '' do

      before do
        EventStream.clear_subscribers
        Assertions.setup_test_subscription
      end

      describe '#assert_event_published' do
        include Assertions


        it 'raise no error when an event has been published' do
          EventStream.publish(:test_event)
          assert_event_published(:test_event)
        end

        it 'raise an error if the event has not been published' do
          assert_raises(Minitest::Assertion) { assert_event_published(:test_event) }
        end
      end

      describe 'registering the test subscription' do
        include Assertions

        it 'not register multiple subscriptions' do
          assert_equal 1, EventStream.default_stream.subscribers.length
        end
      end

      describe '#find_published_event' do
        include Assertions

        it 'find an event if one is present' do
          EventStream.publish(:test_event, key: :val)
          assert find_published_event { |evt| evt.key == :val }
        end

        it 'not find an event if it does not match' do
          EventStream.publish(:test_event, key: :other)
          refute find_published_event { |evt| evt.key == :val }
        end
      end
    end
  end
end

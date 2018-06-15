require_relative '../test_helper'

module EventStream
  class SubscriberDSLTest < Minitest::Test

    class MySubscriber
      include SubscriberDSL

      class << self
        attr_accessor :events
      end

      on(:event) { |event| self.events << event }

      def a_method(event)
        self.class.events << event
      end
    end

    class NameSubscriber
      include SubscriberDSL

      class << self
        attr_accessor :events
      end

      on('event') { |event| self.events << event }

      def a_method(event)
        self.class.events << event
      end
    end

    describe 'The Subscriber DSL' do
      before do
        MySubscriber.events = []
        NameSubscriber.events = []
      end

      describe 'the default stream' do
        before do
          EventStream.clear_subscribers
          MySubscriber.event_stream(EventStream.default_stream)
          MySubscriber.subscribe
        end

        it 'handle a published event' do
          EventStream.publish(:event, test: true)
          assert_equal 1, MySubscriber.events.count
        end
      end

      describe 'NameSubscriber with the default stream' do
        before do
          EventStream.clear_subscribers
          NameSubscriber.event_stream(EventStream.default_stream)
          NameSubscriber.subscribe
        end

        it 'handle a published event' do
          EventStream.publish('event', test: true)
          assert_equal 1, NameSubscriber.events.count
        end
      end

      describe 'other event streams' do
        before do
          @stream = EventStream::Stream.new
          MySubscriber.event_stream(@stream)

          @stream.clear_subscribers
          MySubscriber.subscribe
        end

        it 'handle a published event' do
          @stream.publish(:event, test: true)
          assert_equal 1, MySubscriber.events.count
        end
      end
    end
  end
end

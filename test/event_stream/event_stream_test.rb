require_relative '../test_helper'

class EventStreamTest < Minitest::Test


  describe 'an event stream' do

    def pub_sub(name_or_event, attrs = {}, filter = nil)
      event = nil
      EventStream.subscribe(filter) do |e|
        event = e
      end
      EventStream.publish(name_or_event, attrs)
      event
    end

    before do
      EventStream.default_stream.clear_subscribers
    end

    describe 'publish' do
      it 'publish an event and allow a subscriber to consume it' do
        event = pub_sub(:test)
        assert event
        assert_equal [:test], event.tags
      end

      it 'allow publishing of pre-constructed events' do
        event      = EventStream::Event.new(tags: :test, a: 1)
        subscribed = pub_sub(event)
        assert_equal event, subscribed
      end

      it 'expose all event attributes to the subscriber' do
        event = pub_sub(:test, :x => 1)
        assert_equal 1, event.x
      end

      # filtering events
      it 'allow subscription to event tags' do
        assert pub_sub(:test, {}, :test)
        refute pub_sub(:test, {}, :other_name)
      end

      it 'allow subscription to event tags by regex' do
        assert pub_sub(:test_event, {}, /test/)
        refute pub_sub(:test_event, {}, /no_match/)
      end

      it 'allow subscription by event attributes' do
        assert pub_sub(:test, { :x => 1, :y => :attr }, :y => :attr)
        refute pub_sub(:test, { :x => 1, :y => :other }, :y => :attr)
      end

      it 'allow subscription via arbitrary predicate' do
        predicate = lambda { |e| e.x > 1 }
        assert pub_sub(:test, { :x => 2, :y => :attr }, predicate)
        refute pub_sub(:test, { :x => 1, :y => :attr }, predicate)
      end

      it 'allow subscription via tags array' do
        assert pub_sub([:a, :b, :c], {}, [:a, :b])
        refute pub_sub([:a, :b, :c], {}, [:d, :e])
      end

      it 'allow publish string id' do
        event = EventStream.publish('hello')
        assert_equal 'hello', event.name
        assert_equal :hello, event.tag
        assert_equal [:hello], event.tags
      end

      it 'allow publish symbol id' do
        event = EventStream.publish(:hello)
        assert_equal 'hello', event.name
        assert_equal :hello, event.tag
        assert_equal [:hello], event.tags
      end

      it 'allow publish symbol array is' do
        event = EventStream.publish(%i( world hello ))
        assert_equal 'hello_world', event.name
        assert_equal :hello, event.tag
        assert_equal [:hello, :world], event.tags
      end
    end

  end

  describe 'managing multiple event streams' do

    before do
      EventStream.default_stream.clear_subscribers
    end

    before do
      @stream = EventStream::Stream.new
      EventStream.register_stream(:test_stream, @stream)
    end

    it 'allow streams to be registered and retrieved' do
      assert_equal @stream, EventStream[:test_stream]
    end

    it 'allow separate publishes and subscriptions to different streams' do
      test_event = nil

      EventStream[:test_stream].subscribe(//) do |e|
        test_event = e
      end

      EventStream[:test_stream].publish(:test_event, {})
      assert test_event, "Event was expected to be published to the test stream"
      assert test_event.tags.include?(:test_event)

      test_event = nil

      EventStream.publish(:test_event)
      refute test_event, "No event should have been published to the test stream"
    end
  end
end

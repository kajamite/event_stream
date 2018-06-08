module EventStream
  class Stream
    def initialize
      @subscribers = []
    end

    # Publishes an event to this event stream
    # @param tags [Symbol || Array] name or names of of this event
    # @param attrs [Hash] optional attributes representing this event
    def publish(tags, attrs={})

      if tags.is_a? Event
        event = tags
      else
        tt = [*tags].flatten.select{ |i| i.is_a? Symbol }
        raise ArgumentError, 'tags should be a list of one or more symbols'  if tt.empty?
        event = Event.new(attrs.merge(:tags => tt))
      end

      @subscribers.each { |l| l.consume(event) }
    end

    # Registers a subscriber to this event stream.
    # @param filter [Object] Filters which events this subscriber will consume.
    # If a string or regexp is provided, these will be matched against the event name.
    # A hash will be matched against the attributes of the event.
    # Or, any arbitrary predicate on events may be provided.
    # @yield [Event] action to perform when the event occurs.
    def subscribe(filter = nil, &action)
      add_subscriber(Subscriber.create(filter, &action))
    end

    # Clears all subscribers from this event stream.
    def clear_subscribers
      @subscribers = []
    end

    # Returns all subscribers for this stream
    # @return [Array<EventStream::Subscriber]
    def subscribers
      @subscribers
    end

    # Adds a subscriber to this stream
    # @param [EventStream::Subscriber]
    def add_subscriber(subscriber)
      @subscribers << subscriber
    end
  end
end

module EventCollector
  class << self
    extend Forwardable

    # Returns the stream for a stream name from the stream registry.
    # @param stream_name [Symbol]
    # @return [Stream]
    def [](collector_name)
      CollectorRegistry.lookup(collector_name)
    end

    # Registers a stream, associating it with a specific stream name
    # @param stream_name [Symbol]
    # @param stream [Stream]
    def register_collector(collector_name, collector)
      CollectorRegistry.register(collector_name, collector)
    end

    # The default event stream
    # @return [Stream]
    def default_collector
      self[:default]
    end
    alias :default :default_collector

    def_delegators :default_collector, :<<, :to_a
  end
end

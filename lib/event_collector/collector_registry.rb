require 'active_support/core_ext/class/attribute'

module EventCollector
  class CollectorRegistry

    class UnregisteredCollector < StandardError; end

    class_attribute :collectors
    self.collectors = { default: Collector.new }

    def self.register(stream_name, stream)
      collectors[stream_name] = stream
    end

    def self.lookup(stream_name)
      collectors[stream_name] || (raise UnregisteredCollector)
    end
  end
end
require 'active_support/core_ext/class/attribute'

module EventCollector
  class CollectorRegistry

    class UnregisteredCollector < StandardError; end

    class_attribute :collectors
    self.collectors = { default: Collector.new }

    def self.register(collector_name, collector)
      collectors[collector_name] = collector
    end

    def self.lookup(collector_name)
      collectors[collector_name] = Collector.new if collectors[collector_name].nil?
      collectors[collector_name] #|| (raise UnregisteredCollector)
    end
  end
end
module EventCollector
  class Collector
    attr_accessor :list

    def initialize
      @list = []
    end

    def <<(event)
      list << event
    end

    def [](index)
      @list[index]
    end

    def to_a
      list.clone
    end

    def clear
      @list = []
    end

  end
end
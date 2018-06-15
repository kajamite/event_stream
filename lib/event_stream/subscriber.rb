module EventStream
  class Subscriber < Struct.new(:filter, :action)
    def self.create(filter = nil, &action)
      filter           ||= lambda { |e| true }
      filter_predicate = case filter
      when String
        lambda { |e| e.name == filter }
      when Array
        lambda { |e| ([*e.tags] & filter).any? }
      when Symbol
        lambda { |e| [*e.tags]&.include? filter.to_sym }
      when Regexp
        lambda { |e| [*e.tags].join(' ').to_s =~ filter }
      when Hash
        lambda { |e| filter.all? { |k, v| e[k] === v } }
      else
        filter
      end
      new(filter_predicate, action)
    end

    def consume(event)
      action.call(event) if filter.call(event)
    end
  end
end

require_relative '../test_helper'

module EventStream
  class EventTest < Minitest::Test

    describe 'an event' do

      describe 'creating and accessing values' do
        it 'exposed values passed in as a hash' do
          event = Event.new(a: 1, b: 2)
          assert_equal 1, event.a
          assert_equal 2, event.b
        end

        it 'expose values passed in as string keys' do
          event = Event.new('a' => 1, b: 2)
          assert_equal 1, event.a
        end

        it 'properly respond to existing (but not nonexisting) values' do
          event = Event.new('a' => 1, b: 2)
          assert event.respond_to?(:a)
          assert event.respond_to?(:b)
          refute event.respond_to?(:c)
        end

        it 'can be created with string, tag or tags ids' do
          event = Event.new(name: 'hello')
          assert_equal 'hello', event.name
          assert_equal :hello, event.tag
          assert_equal [:hello], event.tags
        end
      end

      describe '#to_json' do
        it 'serialize to json' do
          event = Event.new(a: 1, b: 2)
          assert_equal '{"a":1,"b":2}', event.to_json
        end
      end

      describe '#from_json' do
        it 'deserialize from json' do
          json  = '{"a":1,"b":2}'
          event = Event.from_json(json)
          assert_equal 1, event.a
          assert_equal 2, event.b
        end

        it 'raise an error if json is not valid' do
          assert_raises(JSON::ParserError) { Event.from_json('not valid') }
        end
      end

      describe 'name works' do

        it 'creates name from ordered tags' do
          event = Event.new(tags: %i(world hello))

          assert_equal event.name, 'hello_world'
        end

      end

    end
  end
end

require "rspec/matcher/identity"
require "active_support/concern"

# Does not monkey patch but is inside RSpec namespace.
module RSpec
  # Provides minimal interface for creating RSpec Matchers.
  #
  # Register matcher with RSpec via `register_as`.
  #
  # Include `RSpec::Matchers::Composable` to support composable matchers.
  #
  # @example
  #   class BeNil
  #     include RSpec::Matcher
  #     register_as "be_nil"
  #
  #     def match
  #       return actual.nil?
  #     end
  #   end
  #
  #   expect(actual).to be_nil
  #
  # ## Required Methods:
  # - `match`
  #
  # ## Optional Methods:
  # - `description`
  # - `failure_message`
  # - `failure_message_when_negated`
  # - `diffable?`
  # - `supports_block_expectations?`
  module Matcher
    extend ActiveSupport::Concern

    # To indicate no value was passed to matcher
    UNDEFINED = Object.new.freeze

    included do
      prepend RSpec::Matcher::PrependedMethods

      attr_accessor :expected, :actual
    end

    # @api private
    # Ensures hook is always called and takes care of control jumps.
    class RescueAndCatch
      attr_accessor :context, :catchable, :to_catch, :rescuable, :to_rescue

      def initialize context, &block
        self.context = context
        instance_eval(&block)
      end

      def result
        r = catch catchable do
          cdo(&to_catch)
        end
        cdo(&to_rescue)

        r
      rescue rescuable => e
        cdo(&to_rescue)
        raise e
      end

      private

      def catching catchable, &block
        self.to_catch = block
        self.catchable = catchable
      end

      def ensuring rescuable, &block
        self.to_rescue = block
        self.rescuable = rescuable
      end

      def cdo &block
        context.instance_eval(&block)
      end
    end

    # @api private
    # Used to let user define initialize
    module PrependedMethods #:nodoc:
      # Stores expected and options then passes remaining args to super
      # @api private
      # @param [any] expected stored as expected and not passed to custom initializer
      # @param [Hash] options stored by calling setter methods
      # @param [any] args... passed to custom initializer
      # @param [Proc] block passed to custom initializer
      def initialize expected = UNDEFINED, options = {}, *args, &block
        self.expected = expected
        options.to_a.each do |option|
          key, value = option
          send("#{key}=", value)
        end
        super(*args, &block)
      end
    end

    # Methods added as class method to includer
    module ClassMethods
      # Registers this matcher in RSpec. Optionally sets options via setter
      # methods on initialize.
      # @example
      #   class BeNil
      #     include RSpec::Matcher
      #     register_as "be_nil"
      #     register_as "be_empty", empty: true
      #     #...
      #   end
      #
      #   expect(nil).to be_nil
      #   expect([]).to be_empty
      #
      # @note self.empty = true is called on initialize
      # @param [String] name what to register this matcher as
      # @return [void]
      def register_as name, options = {}
        s = self
        m = Module.new do
          define_method name do |expected = UNDEFINED, *args, &block|
            s.new(expected, options, *args, &block)
          end
        end

        RSpec.configure do |config|
          config.include m
        end
      end
    end

    # @api private
    # Hides RSpec internal api
    def matches? actual
      self.actual = actual
      RescueAndCatch.new self do
        catching(:resolution) do
          method(:match).arity == 0 ? match : match(actual)
        end

        ensuring(Exception) { clean_up }
      end.result
    end

    # @method actual
    # @example expect(actual).to be(expected)
    # @return [any] value passed to `expect()`

    # @method expected
    # @example expect(actual).to be(expected)
    # @return [any] value passed to matcher function.

    # @method initialize
    # First argument passed to matcher is placed in expected and removed from
    # arg list. Every argument beside that including a block is passed to
    # initialize function.

    # Determines if there is a match or not.
    # @note Must be implemented.
    # @param [any] actual same as actual method.
    # @return [Boolean] true for success, false for failure.
    def match _ = nil
      raise "not implemented"
    end

    # Describes what this matcher does.
    # @example be an string with X length
    # @example match X regex
    # @note for composable matchers
    # @note raises by default
    # @return [String]
    def description
      raise "not implemented"
    end

    # Describe failure.
    # @example "expected EXPECTED to be of length X"
    # @example "expected EXPECTED to match X"
    # @note raises by default
    # @return [String]
    def failure_message
      raise "not implemented"
    end

    # Describe failure when not_to is used.
    # @example "expected EXPECTED not to be of length X"
    # @example "expected EXPECTED not to match X"
    # @note raises by default
    # @return [String]
    def failure_message_when_negated
      raise "not implemented"
    end

    # Indicates if actual and expected should be diffed on failure.
    # @note false by default
    # @return [Boolean]
    def diffable?
      false
    end

    # Indicates if actual can be a block.
    # @example expect { something }.not_to raise_error
    # @note false by default
    # @return [Boolean]
    def supports_block_expectations?
      false
    end

    # Always gets called after decision is made.
    # @return [void]
    def clean_up
    end

    private

    # @api public
    # Stops evaluation and tells RSpec there was a match.
    # @throw :resolution
    # @return [void]
    def resolve_expectation
      throw :resolution, true
    end

    # @api public
    # Stops evaluation and tells RSpec there wasn't a match.
    # @throw :resolution
    # @return [void]
    def reject_expectation
      throw :resolution, false
    end

    # @api public
    # Indicates if expected was passed or not
    def undefined?
      expected == UNDEFINED
    end
  end
end

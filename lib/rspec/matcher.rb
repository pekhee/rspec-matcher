require "rspec/matcher/identity"
require "active_support/concern"

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
    # Used to let user define initialize
    module PrependedMethods
      # @api private
      # @param [any] expected stored as expected and not passed to custom initializer
      # @param [any] params... passed to custom initializer
      # @param [Proc] block passed to custom initializer
      def initialize expected = UNDEFINED, *args, &block
        self.expected = expected
        super(*args, &block)
      end
    end

    # Methods added as class method to includer
    module ClassMethods
      # Registers this matcher in RSpec.
      # @example
      #   class BeNil
      #     include RSpec::Matcher
      #     register_as "be_nil"
      #     #...
      #   end
      #
      #   expect(actual).to be_nil
      #
      # @param [String] name what to register this matcher as
      # @return [void]
      def register_as name
        s = self
        m = Module.new do
          define_method name do |*args, &block|
            s.new(*args, &block)
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
      return match if method(:match).arity == 0

      match actual
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

    # Describes what this matcher does for composable matchers.
    # @example be an string with X length
    # @example match X regex
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
  end
end

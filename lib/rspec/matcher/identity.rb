module RSpec
  module Matcher
    # Gem identity information.
    # @api private
    module Identity #:nodoc:
      def self.name
        "rspec-matcher"
      end

      def self.label
        "RSpec::Matcher"
      end

      def self.version
        "0.1.4"
      end

      def self.version_label
        "#{label} #{version}"
      end
    end
  end
end

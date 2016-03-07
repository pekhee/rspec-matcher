module RSpec
  module Core
    class ExampleGroup
      NOT_IMPORTANT = Object.new.freeze

      def not_important
        NOT_IMPORTANT
      end
    end
  end
end

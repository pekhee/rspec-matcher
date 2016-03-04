module RSpec
  module Matcher
    # Gem identity information.
    module Identity
        def self.name
        "rspec-matcher"
        end

        def self.label
        "RSpec::Matcher"
        end

        def self.version
        "0.1.0"
        end

        def self.version_label
        "#{label} #{version}"
        end
    end
  end
end

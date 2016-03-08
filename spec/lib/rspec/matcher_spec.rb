require "spec_helper"

describe "RSpec::Matcher" do
  let :to_be_nil_matcher do
    Class.new do
      include RSpec::Matcher

      def match actual
        return true if actual.nil?
      end
    end
  end

  subject :instance do
    to_be_nil_matcher.new :expected_probe
  end

  it "is instantiable" do
    expect { subject }.not_to raise_error
  end

  describe "#matches? " do
    let(:matchable) { nil }
    let(:not_matchable) { "anything else" }

    it_behaves_like "is defined", name: :matches?

    it "returns true for a match" do
      expect(instance.matches?(matchable)).to be_truthy
    end

    it "returns false for failure" do
      expect(instance.matches?(not_matchable)).to be_falsy
    end
  end

  describe "#match" do
    it "decides if there is a match" do
      allow(instance).to receive(:match).with(not_important).and_return true
      expect(instance.matches?(not_important)).to be_truthy
    end

    it "decides if there isn't a match" do
      allow(instance).to receive(:match).with(not_important).and_return false
      expect(instance.matches?(not_important)).to be_falsy
    end

    it "works with arity of 0" do
      instance.instance_eval do
        def match
          raise "correct invocation"
        end
      end

      expect { instance.matches? not_important }.to raise_error "correct invocation"
    end
  end

  describe "#actual" do
    it_behaves_like "is defined", name: :actual

    it "is first arg of #matches? and accessible from #match" do
      instance.instance_eval do
        def match _
          raise "wrong value" if actual != :actual_probe

          true
        end
      end

      expect { instance.matches? :actual_probe }.not_to raise_error
    end
  end

  describe "#expected" do
    it_behaves_like "is defined", name: :expected

    it "is first arg of .new and accessible from #match" do
      instance.instance_eval do
        def match _
          raise "wrong value" if expected != :expected_probe

          true
        end
      end

      expect { instance.matches? not_important }.not_to raise_error
    end
  end

  describe "expectation resolution control" do
    describe "#resolve_expectation" do
      it_behaves_like "is defined", name: "resolve_expectation"

      it "resolves matcher" do
        matcher = Class.new do
          include RSpec::Matcher

          def match
            resolve_expectation

            false
          end
        end.new

        expect(matcher.matches? not_important).to be_truthy
      end
    end

    describe "#reject_expectation" do
      it_behaves_like "is defined", name: "reject_expectation"

      it "rejects matcher" do
        matcher = Class.new do
          include RSpec::Matcher

          def match
            reject_expectation

            false
          end
        end.new

        expect(matcher.matches? not_important).to be_falsy
      end
    end
  end

  describe "main rspec interface" do
    subject :instance do
      Class.new do
        include RSpec::Matcher
      end.new not_important
    end

    [:match, :description, :failure_message, :failure_message_when_negated].each do |interface|
      describe "##{interface}" do
        it_behaves_like "default hook", name: interface, raises: "not implemented"
      end
    end
  end

  context "predicates interface" do
    [:diffable?, :supports_block_expectations?].each do |predicate|
      describe "##{predicate}" do
        it_behaves_like "default hook", name: predicate, defaults_to: false
      end
    end
  end

  context "when registered with RSpec" do
    before :all do
      Class.new do
        include RSpec::Matcher
        register_as "be_nil"

        def match
          actual.nil?
        end
      end
    end

    it "is available as name passed to register as" do
      expect(self).to respond_to :be_nil
    end

    it "works with or without passing expected" do
      expect(be_nil(not_important).matches?(nil)).to be_truthy
      expect(be_nil.matches?(nil)).to be_truthy
    end
  end
end

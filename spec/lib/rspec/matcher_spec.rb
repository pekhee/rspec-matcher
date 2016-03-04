require "spec_helper"

describe "RSpec::Matcher" do
  subject do
    Class.new do
      include RSpec::Matcher
    end
  end

  it "should be instantiable" do
    expect {subject.new}.not_to raise_error
  end
end

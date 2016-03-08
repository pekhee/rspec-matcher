RSpec.shared_examples "is defined" do |name:|
  it "is defined" do
    expect(subject.respond_to?(name, true)).to be_truthy
  end
end

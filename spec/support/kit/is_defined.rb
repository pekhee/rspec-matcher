RSpec.shared_examples "is defined" do |name:|
  it "is defined" do
    expect(subject).to respond_to name
  end
end

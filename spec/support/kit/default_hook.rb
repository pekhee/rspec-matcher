RSpec.shared_examples "default hook" do |name:, defaults_to: nil, raises: nil|
  if defaults_to.nil? && raises.nil?
    raise ArgumentError, "either defaults_to or raises should be given"
  end

  it_behaves_like "is defined", name: name

  if raises.nil?
    it "returns #{defaults_to} by default" do
      expect(subject.send(name)).to eq(defaults_to)
    end
  else
    it "raises #{raises} by default" do
      expect { subject.send(name) }.to raise_error raises
    end
  end
end

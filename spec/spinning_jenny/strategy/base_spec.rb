require 'spinning_jenny/strategy/base'

describe SpinningJenny::Strategy::Base do
  let(:example_class) { Class.new }

  describe "#instantiate" do
    it "creates a new instance of a class" do
      subject.instantiate(example_class).should be_kind_of(example_class)
    end
  end
end

require 'spinning_jenny/strategy/build'

describe SpinningJenny::Strategy::Build do
  it "inherits from Base" do
    subject.should be_kind_of(SpinningJenny::Strategy::Base)
  end

  describe "#execute" do
    let(:example_class) { Class.new }

    it "instantiates a new object" do
      subject.should_receive(:instantiate).with example_class
      subject.execute example_class
    end

    let(:properties) { {:property => 'value'} }
    it "sets the properties of the object" do
      subject.should_receive(:set_properties).with anything, properties
      subject.execute example_class, properties
    end
  end

  describe "#set_properties" do
    let(:object) { Object.new }
    let(:properties) { {:prop1 => 'value'} }
    it "calls the setters of the object" do
      object.should_receive(:prop1=).with 'value'
      subject.set_properties object, properties
    end
  end
end

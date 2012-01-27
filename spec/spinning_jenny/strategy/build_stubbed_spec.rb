require 'spinning_jenny/strategy/build_stubbed'

describe SpinningJenny::Strategy::BuildStubbed do
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
      subject.should_receive(:stub_properties).with anything, properties
      subject.execute example_class, properties
    end
  end

  describe "#stub_properties" do
    let(:object) { Object.new }
    let(:properties) { {:prop1 => 'value'} }

    it "the stubbed property methods return the values" do
      subject.stub_properties object, properties
      object.prop1.should == 'value'
    end
  end
end

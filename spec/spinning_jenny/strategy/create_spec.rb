require 'spinning_jenny/strategy/create'

describe SpinningJenny::Strategy::Create do
  it "inherits from Build" do
    subject.should be_kind_of(SpinningJenny::Strategy::Build)
  end

  describe "#execute" do
    let(:example_class) do
      Class.new do
        def save
        end
      end
    end

    it "instantiates a new object" do
      subject.stub(:instantiate) { example_class.new }
      subject.should_receive(:instantiate).with example_class
      subject.execute example_class
    end

    let(:properties) { {:property => 'value'} }
    it "sets the properties of the object" do
      subject.should_receive(:set_properties).with anything, properties
      subject.execute example_class, properties
    end

    it "saves the instance" do
      subject.should_receive(:persist_object)
      subject.execute example_class
    end
  end

  describe "#persist_object" do
    let(:object) { Object.new }
    it "saves the object" do
      object.should_receive :save
      subject.persist_object object
    end
  end
end

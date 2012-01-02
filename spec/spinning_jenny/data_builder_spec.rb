require 'spinning_jenny/data_builder'

describe SpinningJenny::DataBuilder do
  let(:sample_class) do
    class Order
      attr_accessor :my_property
    end
    Order
  end
  let(:blueprint) { SpinningJenny::Blueprint.new sample_class }
  subject { SpinningJenny::DataBuilder.new(blueprint) }

  describe "#initialize" do
    it "stores a blueprint" do
      builder = SpinningJenny::DataBuilder.new(blueprint)
      builder.blueprint.should == blueprint
    end

  end

  describe "#build" do
    it "creates an object of type described by the blueprint" do
      subject.build.should be_kind_of(sample_class)
    end

    it "calls the setters for the default values of the blueprint" do
      blueprint.default_values['my_property'] = 'value'
      subject.build.my_property.should == 'value'
    end

    it "calls the setters for the values of the data builder" do
      subject.values['my_property'] = 'empty'
      subject.build.my_property.should == 'empty'
    end
  end

  describe "#with" do
    it "returns a new data builder with the same blueprint" do
      builder = subject.with(:delivery => :express)
      builder.blueprint.should == subject.blueprint
      builder.should_not == subject
    end

    it "stores the value for the new object" do
      builder = subject.with(:delivery => :express)
      builder.object_values['delivery'].should == :express
    end
  end

  describe "#object_values" do
    it "contains the default values from the blueprint" do
      blueprint.delivery :slow
      subject.object_values['delivery'].should == :slow
    end

    it "contains values from the data builder" do
      subject.values['delivery'] = :max
      subject.object_values['delivery'].should == :max
    end
  end
end

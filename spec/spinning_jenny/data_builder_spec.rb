require 'spinning_jenny'
require 'spinning_jenny/data_builder'

describe SpinningJenny::DataBuilder do
  class Order
    attr_accessor :my_property
    def save
    end
  end
  class Item
  end
  let(:blueprint) { SpinningJenny::Blueprint.new Order }
  subject { SpinningJenny::DataBuilder.new(blueprint) }

  describe "#initialize" do
    it "stores a blueprint" do
      builder = SpinningJenny::DataBuilder.new(blueprint)
      builder.blueprint.should == blueprint
    end
  end

  describe "#instantiate" do
    it "delegates to the object creation strategy of the blueprint" do
      blueprint.object_creation_strategy = :setter
      SpinningJenny::ObjectCreation::Setter.should_receive(:instantiate).with(Order, 'my_property' => :value)
      subject.with(:my_property => :value).instantiate
    end

    it "delegates to the object creation strategy of the global configuration" do
      SpinningJenny.configuration.object_creation_strategy = :setter
      SpinningJenny::ObjectCreation::Setter.should_receive(:instantiate).with(Order, 'my_property' => :value)
      subject.with(:my_property => :value).instantiate
    end
  end

  describe "#build" do
    let(:instance) { Order.new }

    it "instantiates a new object" do
      subject.stub(:instantiate) { instance }
      subject.build.should == instance
    end
  end

  describe "#create" do
    let(:instance) { Order.new }

    it "instantiates a new object" do
      subject.stub(:instantiate) { instance }
      subject.create.should == instance
    end

    it "saves the instance" do
      instance.should_receive(:save)
      subject.stub(:instantiate) { instance }
      subject.create
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

  describe "#without" do
    it "returns a new data builder with the same blueprint" do
      builder = subject.with(:delivery => :express)
      builder.blueprint.should == subject.blueprint
      builder.should_not == subject
    end

    it "stores the property to ignore" do
      builder = subject.without(:delivery)
      builder.object_values['delivery'].should be_nil
    end
  end

  describe "#object_values" do
    it "contains the default values from the blueprint" do
      blueprint.delivery :slow
      subject.object_values['delivery'].should == :slow
    end

    it "contains values from the data builder" do
      builder = subject.with('delivery' => :max)
      builder.object_values['delivery'].should == :max
    end

    it "doesn't set properties on the ignore list" do
      builder = subject.with('delivery' => :max)
      builder = builder.without('delivery')
      builder.object_values.should_not include('delivery')
    end

    it "generates objects if a value is another data builder" do
      item_blueprint = SpinningJenny::Blueprint.new Item
      item_builder = SpinningJenny::DataBuilder.new item_blueprint
      builder = subject.with('item' => item_builder)
      builder.object_values['item'].should be_kind_of(Item)
    end

    it "executes blocks for object values" do
      builder = subject.with('delivery' => Proc.new { :value })
      builder.object_values['delivery'].should == :value
    end
  end
end

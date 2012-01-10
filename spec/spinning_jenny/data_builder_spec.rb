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

  describe "#with" do
    it "returns a new data builder with the same blueprint" do
      builder = subject.with(:delivery => :express)
      builder.blueprint.should == subject.blueprint
      builder.should_not == subject
    end

    it "stores the value for the new object" do
      builder = subject.with(:delivery => :express)
      builder.raw_object_values['delivery'].should == :express
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
      builder.raw_object_values['delivery'].should be_nil
    end
  end

  describe "#execute_with_strategy" do
    class DummyStrategy
      def execute(class_to_instantiate, properties = {})
      end
    end

    it "finds the strategy" do
      SpinningJenny::Strategy.stub(:by_name) { DummyStrategy.new }
      SpinningJenny::Strategy.should_receive(:by_name).with('abc')
      subject.execute_with_strategy('abc')
    end

    it "executes the strategy" do
      SpinningJenny::Strategy.stub(:by_name) { DummyStrategy.new }
      DummyStrategy.any_instance.should_receive(:execute).with(blueprint.describing_class, {})
      subject.execute_with_strategy('abc')
    end
  end

  describe "#raw_object_values" do
    it "contains the default values from the blueprint" do
      blueprint.delivery :slow
      subject.raw_object_values['delivery'].should == :slow
    end

    it "contains values from the data builder" do
      builder = subject.with('delivery' => :max)
      builder.raw_object_values['delivery'].should == :max
    end

    it "doesn't set properties on the ignore list" do
      builder = subject.with('delivery' => :max)
      builder = builder.without('delivery')
      builder.raw_object_values.should_not include('delivery')
    end
  end

  describe "#calculated_object_values" do
    let(:item_blueprint) { SpinningJenny::Blueprint.new Item }
    let(:item_builder) { SpinningJenny::DataBuilder.new item_blueprint }

    it "generates objects if a value is another data builder" do
      property_hash = SpinningJenny::PropertyHash.from_hash(:item => item_builder)
      subject.stub(:raw_object_values) { property_hash }
      subject.calculated_object_values['item'].should be_kind_of(Item)
    end

    it "executes blocks for object values" do
      property_hash = SpinningJenny::PropertyHash.from_hash(:delivery => Proc.new { :value })
      subject.stub(:raw_object_values) { property_hash }
      subject.calculated_object_values['delivery'].should == :value
    end
  end

  describe "#method_missing" do
    it "looks for a strategy with the method name" do
      SpinningJenny::Strategy.stub(:exists?) { true }
      SpinningJenny::Strategy.should_receive(:exists?).with(:build)
      subject.build
    end

    it "calls #execute_with_strategy" do
      SpinningJenny::Strategy.stub(:exists?) { true }
      subject.should_receive(:execute_with_strategy).with(:build)
      subject.build
    end
  end
end

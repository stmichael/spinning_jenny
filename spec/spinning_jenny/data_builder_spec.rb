require 'spinning_jenny/data_builder'

describe SpinningJenny::DataBuilder do
  class Order
    attr_accessor :my_property
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

  describe "#build" do
    it "creates an object of type described by the blueprint" do
      subject.build.should be_kind_of(Order)
    end

    it "calls the setters for the default values of the blueprint" do
      blueprint.default_values['my_property'] = 'value'
      subject.build.my_property.should == 'value'
    end

    it "calls the setters for the values of the data builder" do
      builder = subject.with('my_property' => 'empty')
      builder.build.my_property.should == 'empty'
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

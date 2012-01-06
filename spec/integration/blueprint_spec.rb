require 'spinning_jenny'

describe SpinningJenny do
  class Order
    attr_accessor :delivery, :item
  end
  class Item
    attr_accessor :name
  end

  before :each do
    subject.configuration.clear_blueprints
  end

  it "defines default values for blueprints" do
    SpinningJenny.blueprint Order do |b|
      b.delivery :express
    end
    object = SpinningJenny.builder_for(Order).build
    object.should be_kind_of(Order)
    object.delivery.should == :express
  end

  it "lets you name blueprints specifically" do
    SpinningJenny.blueprint Order, :name => 'special_order' do |b|
      b.delivery :special
    end
    object = SpinningJenny.builder_for('special_order').build
    object.should be_kind_of(Order)
    object.delivery.should == :special
  end

  it "defines object dependencies on blueprint level" do
    SpinningJenny.blueprint Item do |b|
      b.name 'item1'
    end
    SpinningJenny.blueprint Order do |b|
      b.item SpinningJenny.builder_for(Item)
    end
    builder = SpinningJenny.builder_for(Order)
    object = builder.build
    object.item.should be_kind_of(Item)
    object.item.name.should == 'item1'
  end

  it "defines object values evaluated at object creation" do
    SpinningJenny.blueprint Order do |b|
      b.delivery { 'delayed' }
    end
    object = SpinningJenny.builder_for(Order).build
    object.should be_kind_of(Order)
    object.delivery.should == 'delayed'
  end

end

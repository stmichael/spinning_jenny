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

  it "defines values on data builder level" do
    SpinningJenny.blueprint Order do |b|
      b.delivery :express
    end
    builder = SpinningJenny.builder_for(Order).
      with(:delivery => :slow)
    object = builder.build
    object.delivery.should == :slow
  end

  it "lets you name blueprints specifically" do
    SpinningJenny.blueprint Order, :name => 'special_order' do |b|
      b.delivery :special
    end
    object = SpinningJenny.builder_for('special_order').build
    object.should be_kind_of(Order)
    object.delivery.should == :special
  end

  it "ignores properties" do
    SpinningJenny.blueprint Order do |b|
      b.delivery :ignore
    end
    builder = SpinningJenny.builder_for(Order).
      without(:delivery)
    object = builder.build
    object.delivery.should be_nil
  end

  it "defines object dependencies on data builder level" do
    SpinningJenny.blueprint Item do |b|
      b.name 'item1'
    end
    SpinningJenny.blueprint Order do |b|
      b.delivery :speed
    end
    builder = SpinningJenny.builder_for(Order).
      with(:item => SpinningJenny.builder_for(Item))
    object = builder.build
    object.item.should be_kind_of(Item)
    object.item.name.should == 'item1'
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

  it "creates a data builder of a blueprint beginning with a consonant" do
    blueprint = SpinningJenny.blueprint Order, :name => :special_order do |b|
      b.delivery :special
    end
    builder = SpinningJenny.a_special_order
    builder.blueprint.should == blueprint
  end

  it "creates a data builder of a blueprint beginning with a vowel" do
    blueprint = SpinningJenny.blueprint Order do |b|
      b.delivery :normal
    end
    builder = SpinningJenny.an_order
    builder.blueprint.should == blueprint
  end

  class PersistedOrder
    attr_accessor :price
    attr_reader :saved

    def initialize
      @saved = false
    end

    def save
      @saved = true
    end
  end
  it "instantiates and persists an object" do
    SpinningJenny.blueprint PersistedOrder do |b|
      b.price 28
    end
    object = SpinningJenny.a_persisted_order.create
    object.saved.should be_true
    object.price.should == 28
  end
end

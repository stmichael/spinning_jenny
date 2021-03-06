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

  it "defines values on data builder level" do
    SpinningJenny.blueprint Order do |b|
      b.delivery :express
    end
    builder = SpinningJenny.builder_for(Order).
      with(:delivery => :slow)
    object = builder.build
    object.delivery.should == :slow
  end

  it "ignores specific properties" do
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
    attr_accessor :item
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

  class PersistedItem
    attr_reader :saved

    def initialize
      @saved = false
    end

    def save
      @saved = true
    end
  end
  it "instantiates and persists item and order" do
    SpinningJenny.blueprint PersistedItem do |b|
    end
    SpinningJenny.blueprint PersistedOrder do |b|
      b.item SpinningJenny.builder_for(PersistedItem)
    end
    object = SpinningJenny.a_persisted_order.create
    object.saved.should be_true
    object.item.should be_kind_of(PersistedItem)
    object.item.saved.should be_true
  end

  class StubbedOrder
    attr_writer :delivery
    def delivery
      "delivery: #{@delivery}"
    end
  end
  it "instantiates an object and stubs its properties" do
    SpinningJenny.blueprint StubbedOrder do |b|
      b.delivery :speed
    end
    object = SpinningJenny.a_stubbed_order.build_stubbed
    object.delivery.should == :speed
  end
end

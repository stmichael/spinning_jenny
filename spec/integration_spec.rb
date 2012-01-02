require 'spinning_jenny'

describe SpinningJenny do
  let(:sample_class) do
    class Order
      attr_accessor :delivery
    end
    Order
  end

  before :each do
    subject.configuration.clear_blueprints
  end

  it "lets you define default values for blueprints" do
    SpinningJenny.blueprint sample_class do |b|
      b.delivery :express
    end
    object = SpinningJenny.builder_for(sample_class).build
    object.should be_kind_of(sample_class)
    object.delivery.should == :express
  end

  it "lets you define values at object creation time" do
    SpinningJenny.blueprint sample_class do |b|
      b.delivery :express
    end
    builder = SpinningJenny.builder_for(sample_class).
      with(:delivery => :slow)
    object = builder.build
    object.delivery.should == :slow
  end

  it "lets you name blueprints specifically" do
    SpinningJenny.blueprint sample_class, :name => 'special_order' do |b|
      b.delivery :special
    end
    object = SpinningJenny.builder_for('special_order').build
    object.should be_kind_of(sample_class)
    object.delivery.should == :special
  end
end

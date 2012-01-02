require 'spinning_jenny'

describe SpinningJenny do
  let(:sample_class) do
    class Order
      attr_accessor :delivery
    end
    Order
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
    builder = SpinningJenny.builder_for(sample_class).
      with(:delivery => :express)
    object = builder.build
    object.delivery.should == :express
  end
end

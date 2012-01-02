require 'spinning_jenny/object_creation/setter'

describe SpinningJenny::ObjectCreation::Setter do
  class Order
    attr_accessor :my_property
  end
  subject { SpinningJenny::ObjectCreation::Setter }

  describe ".build" do
    it "creates an object of type described by the blueprint" do
      subject.build(Order).should be_kind_of(Order)
    end

    it "calls the setters for the values" do
      object = subject.build(Order, 'my_property' => 'value')
      object.my_property.should == 'value'
    end
  end
end
require 'spinning_jenny/object_creation/setter'

describe SpinningJenny::ObjectCreation::Setter do
  class SetterOrder
    attr_accessor :my_property
  end
  subject { SpinningJenny::ObjectCreation::Setter }

  describe ".instantiate" do
    it "creates an object of type described by the blueprint" do
      subject.instantiate(SetterOrder).should be_kind_of(SetterOrder)
    end

    it "calls the setters for the values" do
      object = subject.instantiate(SetterOrder, 'my_property' => 'value')
      object.my_property.should == 'value'
    end
  end
end

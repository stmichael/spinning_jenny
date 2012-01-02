require 'spinning_jenny/object_creation/value_hash'

describe SpinningJenny::ObjectCreation::ValueHash do
  class ValueHashOrder
    attr_reader :values

    def initialize(values)
      @values = values
    end
  end
  subject { SpinningJenny::ObjectCreation::ValueHash }

  describe ".build" do
    it "creates an object of type described by the blueprint" do
      subject.build(ValueHashOrder).should be_kind_of(ValueHashOrder)
    end

    it "initializes the objects properties" do
      object = subject.build(ValueHashOrder, 'my_property' => 'value')
      object.values['my_property'].should == 'value'
    end
  end
end

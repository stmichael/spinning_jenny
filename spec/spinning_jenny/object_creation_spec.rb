require 'spinning_jenny/object_creation'

describe SpinningJenny::ObjectCreation do
  subject { SpinningJenny::ObjectCreation }

  describe ".strategy" do
    it "creates an instance of the setter strategy" do
      subject.strategy(:setter).should == SpinningJenny::ObjectCreation::Setter
    end

    it "throws an exception if no strategy has been found" do
      lambda { subject.strategy(:some_other_strategy) }.should raise_error
    end
  end
end

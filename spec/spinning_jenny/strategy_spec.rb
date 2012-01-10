require 'spinning_jenny/strategy'

describe SpinningJenny::Strategy do
  subject { SpinningJenny::Strategy }

  describe ".by_name" do
    it "returns an instance of the builder strategy" do
      subject.by_name(:build).should be_kind_of(SpinningJenny::Strategy::Build)
    end

    it "returns an instance of the create strategy" do
      subject.by_name(:create).should be_kind_of(SpinningJenny::Strategy::Create)
    end

    it "raises an error if no strategy has been found" do
      lambda { subject.by_name(:abc) }.should raise_error
    end
  end

  describe ".exists?" do
    it "returns true if the strategy exists" do
      subject.exists?(:build).should be_true
    end

    it "returns false if the strategy doesn't exist" do
      subject.exists?(:abc).should be_false
    end
  end

  describe ".name_to_class_name" do
    it "transform a name into a class name" do
      subject.send(:name_to_class_name, :build).should == 'Build'
    end
  end
end

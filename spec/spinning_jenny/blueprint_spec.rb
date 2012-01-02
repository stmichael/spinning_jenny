require 'spinning_jenny/blueprint'

describe SpinningJenny::Blueprint do
  let(:sample_class) { Class.new }
  subject { SpinningJenny::Blueprint.new sample_class }

  describe "#initialize" do
    it "stores the class that the blueprint describes" do
      blueprint = SpinningJenny::Blueprint.new(sample_class)
      blueprint.describing_class.should == sample_class
    end
  end

  describe "property methods" do
    it "sets the default value for a specific property" do
      subject.my_property :value
      subject.default_values['my_property'].should == :value
    end

    it "sets a block as a default value" do
      subject.my_property { :value }
      subject.default_values['my_property'].should be_kind_of(Proc)
      subject.default_values['my_property'].call.should == :value
    end
  end
end

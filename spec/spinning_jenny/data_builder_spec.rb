require 'spinning_jenny/data_builder'

describe SpinningJenny::DataBuilder do
  let(:sample_class) { Class.new }
  let(:blueprint) { SpinningJenny::Blueprint.new sample_class }
  subject { SpinningJenny::DataBuilder.new(blueprint) }

  describe "#initialize" do
    it "stores a blueprint" do
      builder = SpinningJenny::DataBuilder.new(blueprint)
      builder.blueprint.should == blueprint
    end

  end

  describe "#build" do
    it "creates an object of type described by the blueprint" do
      subject.build.should be_kind_of(sample_class)
    end
  end
end

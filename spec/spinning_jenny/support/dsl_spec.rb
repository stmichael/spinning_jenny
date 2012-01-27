require 'spinning_jenny/support/dsl'

describe SpinningJenny::Support::DSL do
  subject do
    Class.new do
      extend SpinningJenny::Support::DSL
    end
  end
  let(:example_class) { Class.new }

  before :each do
    SpinningJenny.configuration.clear_blueprints
  end

  describe "#build" do
    it "builds an objects" do
      SpinningJenny.blueprint example_class, :name => :ueli do |b|
      end
      SpinningJenny::DataBuilder.any_instance.should_receive(:build)
      subject.build(:ueli)
    end
  end

  describe "#create" do
    it "creates an objects" do
      SpinningJenny.blueprint example_class, :name => :ueli do |b|
      end
      SpinningJenny::DataBuilder.any_instance.should_receive(:create)
      subject.create(:ueli)
    end
  end

  describe "#build_stubbed" do
    it "creates an objects" do
      SpinningJenny.blueprint example_class, :name => :ueli do |b|
      end
      SpinningJenny::DataBuilder.any_instance.should_receive(:build_stubbed)
      subject.build_stubbed(:ueli)
    end
  end
end

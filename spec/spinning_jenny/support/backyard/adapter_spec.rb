require 'spinning_jenny/support/backyard/adapter'

describe Backyard::Adapter::SpinningJenny do
  let(:example_class) do
    Class.new do
      attr_accessor :property
      def save
      end
    end
  end

  before :each do
    ::SpinningJenny.configuration.clear_blueprints
  end

  describe "#class_for_type" do
    it "returns the class of the blueprint" do
      ::SpinningJenny.blueprint example_class, :name => :ueli do |b|
      end
      subject.class_for_type(:ueli).should == example_class
    end
  end

  describe "#create" do
    it "creates a new instance of the class" do
      ::SpinningJenny.blueprint example_class, :name => :ueli do |b|
      end
      object = subject.create(:ueli, :property => 'value')
      object.property.should == 'value'
    end
  end
end

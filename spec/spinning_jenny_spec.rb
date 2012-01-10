require 'spinning_jenny'

describe SpinningJenny do
  let(:sample_class) do
    class Order
      attr_accessor :delivery
    end
    Order
  end

  describe ".configuration" do
    it "returns a configuration instance" do
      subject.configuration.should be_kind_of(SpinningJenny::Configuration)
    end
  end

  describe ".blueprint" do
    subject { SpinningJenny }
    let(:blueprint) { SpinningJenny::Blueprint.new sample_class }

    it "yields the blueprint if it exists" do
      subject.configuration.stub(:named_blueprint) { blueprint }

      subject.blueprint sample_class do |b|
        b.should == blueprint
      end
    end

    it "yields a new blueprint if it doesn't exist" do
      subject.configuration.stub(:named_blueprint) { nil }

      subject.blueprint sample_class do |b|
        b.describing_class.should == sample_class
      end

      subject.configuration.blueprints['order'].describing_class.should == sample_class
    end

    it "accepts a name for the blueprint" do
      subject.blueprint sample_class, :name => 'my_order' do |b|
        b.describing_class.should == sample_class
      end

      subject.configuration.blueprints['my_order'].should_not be_nil
    end

    it "accepts a string as class" do
      subject.blueprint 'Order' do |b|
        b.describing_class.should == sample_class
      end
    end

    it "accepts a symbol as class" do
      subject.blueprint :Order do |b|
        b.describing_class.should == sample_class
      end
    end
  end

  describe ".builder_for" do
    subject { SpinningJenny }
    let(:blueprint) { SpinningJenny::Blueprint.new sample_class }

    before :each do
      subject.configuration.blueprints['order'] = blueprint
    end

    it "returns a data builder for the registered blueprint" do
      subject.builder_for(sample_class).blueprint.should == blueprint
    end

    it "accepts a string for the builder name" do
      subject.builder_for('order').blueprint.should == blueprint
    end

    it "accepts a symbol for the builder name" do
      subject.builder_for(:order).blueprint.should == blueprint
    end
  end

  describe ".class_name_to_real_name" do
    it "returns lowercased class name" do
      subject.class_name_to_real_name('Order').should == 'order'
    end

    it "returns camelcased class name replaced by underscores" do
      subject.class_name_to_real_name('MyOrder').should == 'my_order'
    end
  end
end

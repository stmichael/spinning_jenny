require 'spinning_jenny'

describe SpinningJenny do

  let(:sample_class) do
    class Order
      attr_accessor :delivery
    end
    Order
  end

  it "lets you define default values for blueprints" do
    SpinningJenny.blueprint sample_class do |b|
      b.delivery :express
    end
    object = SpinningJenny.builder_for(sample_class).build
    object.should be_kind_of(sample_class)
    object.delivery.should == :express
  end

  describe ".blueprint" do
    subject { SpinningJenny }
    let(:blueprint) { SpinningJenny::Blueprint.new sample_class }

    before :each do
      subject.clear_blueprints
    end

    it "yields the blueprint if it exists" do
      subject.stub(:named_blueprint) { blueprint }

      subject.blueprint sample_class do |b|
        b.should == blueprint
      end
    end

    it "yields a new blueprint if it doesn't exist" do
      subject.stub(:named_blueprint) { nil }

      subject.blueprint sample_class do |b|
        b.describing_class.should == sample_class
      end

      subject.blueprints['order'].describing_class.should == sample_class
    end
  end

  describe ".builder_for" do
    subject { SpinningJenny }
    let(:blueprint) { SpinningJenny::Blueprint.new sample_class }

    it "returns a data builder for the registered blueprint" do
      subject.clear_blueprints
      subject.blueprints['order'] = blueprint
      subject.builder_for(sample_class).blueprint.should == blueprint
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

  describe ".named_blueprint" do
    subject { SpinningJenny }
    let(:blueprint) { SpinningJenny::Blueprint.new sample_class }

    before :each do
      subject.clear_blueprints
    end

    it "returns an existing blueprint" do
      subject.stub(:blueprints) { {'order' => blueprint} }
      subject.send(:named_blueprint, 'order').should == blueprint
    end

    it "returns nil if no blueprint exists" do
      subject.send(:named_blueprint, 'order').should be_nil
    end
  end

  describe ".create_blueprint" do
    before :each do
      subject.clear_blueprints
    end

    it "creates a new blueprint if it doesn't exist" do
      blueprint = subject.send(:create_blueprint, sample_class)
      blueprint.should be_kind_of(SpinningJenny::Blueprint)
      blueprint.describing_class.should == sample_class
    end

    it "caches the created blueprint" do
      blueprint = subject.send(:create_blueprint, sample_class)
      subject.named_blueprint('order').should_not be_nil
    end
  end

  describe ".clear_blueprints" do
    it "removes all blueprints" do
      subject.blueprints['order'] = :my_blueprint
      subject.clear_blueprints
      subject.blueprints.should be_empty
    end
  end
end

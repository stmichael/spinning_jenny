require 'spinning_jenny/configuration'

describe SpinningJenny::Configuration do
  let(:sample_class) do
    class Order; end
    Order
  end

  describe "#initialize" do
    it "sets the default object creation strategy to setter" do
      subject.object_creation_strategy.should == :setter
    end
  end

  describe "#named_blueprint" do
    let(:blueprint) { SpinningJenny::Blueprint.new sample_class }

    it "returns an existing blueprint" do
      subject.stub(:blueprints) { {'order' => blueprint} }
      subject.send(:named_blueprint, 'order').should == blueprint
    end

    it "returns nil if no blueprint exists" do
      subject.send(:named_blueprint, 'order').should be_nil
    end
  end

  describe "#create_blueprint" do
    it "creates a new blueprint if it doesn't exist" do
      blueprint = subject.send(:create_blueprint, 'order', sample_class)
      blueprint.should be_kind_of(SpinningJenny::Blueprint)
      blueprint.describing_class.should == sample_class
    end

    it "caches the created blueprint" do
      blueprint = subject.send(:create_blueprint, 'order', sample_class)
      subject.named_blueprint('order').should_not be_nil
    end

    it "calls the setter methods of all additional properties" do
      blueprint = subject.send(:create_blueprint, 'order', sample_class, :object_creation_strategy => :abc)
      blueprint.object_creation_strategy.should == :abc
    end
  end

  describe "#clear_blueprints" do
    it "removes all blueprints" do
      subject.blueprints['order'] = :my_blueprint
      subject.clear_blueprints
      subject.blueprints.should be_empty
    end
  end
end

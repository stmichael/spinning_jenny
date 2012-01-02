require 'spinning_jenny/property_hash'

describe SpinningJenny::PropertyHash do
  describe ".from_hash" do
    let(:hash) { {:key => :value} }

    it "converts a hash into a property hash" do
      property_hash = SpinningJenny::PropertyHash.from_hash(hash)
      property_hash.should be_kind_of(SpinningJenny::PropertyHash)
      property_hash['key'].should == :value
      property_hash.should_not include(:key)
    end
  end

  describe "#[]=" do
    it "converts the keys into strings" do
      subject[:key] = :value
      subject.should include('key')
      subject.should_not include(:key)
      subject['key'].should == :value
    end
  end
end

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

  describe "#merge" do
    let(:other_hash) { SpinningJenny::PropertyHash.from_hash(:key2 => :value2) }

    it "merges to property hashes" do
      subject[:key] = :value
      property_hash = subject.merge(other_hash)
      property_hash['key'].should == :value
      property_hash['key2'].should == :value2
    end
  end

  describe "#reject!" do
    it "removes symbol keys from the hash" do
      subject[:key] = :value
      subject.reject! :key
      subject.should_not include('key')
    end

    it "removes string keys from the hash" do
      subject[:key] = :value
      subject.reject! 'key'
      subject.should_not include('key')
    end

    it "removes multiple keys from the hash" do
      subject[:key] = :value
      subject['key2'] = :value
      subject.reject! :key, 'key2'
      subject.should_not include('key')
      subject.should_not include('key2')
    end

    it "removes array of keys" do
      subject[:key] = :value
      subject['key2'] = :value
      subject.reject! [:key, 'key2']
      subject.should_not include('key')
      subject.should_not include('key2')
    end
  end
end

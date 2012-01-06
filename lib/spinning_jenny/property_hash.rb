module SpinningJenny
  class PropertyHash
    def self.from_hash(hash)
      property_hash = self.new
      hash.each do |key, value|
        property_hash[key] = value
      end
      property_hash
    end

    def initialize
      @internal_hash = {}
    end

    def []=(name, value)
      @internal_hash[name.to_s] = value
    end

    def [](name)
      @internal_hash[name]
    end

    def include?(key)
      @internal_hash.include? key
    end

    def merge(other_hash)
      property_hash = other_hash
      property_hash = PropertyHash.from_hash(property_hash) if property_hash.kind_of?(Hash)

      PropertyHash.from_hash self.to_hash.merge(property_hash.to_hash)
    end

    def reject!(*keys)
      if keys.size == 1 && keys.first.kind_of?(Array)
        keys = keys.first
      end
      @internal_hash.reject! {|key, value| keys.include?(key) || keys.include?(key.to_sym)}
    end

    def to_hash
      @internal_hash
    end
  end
end

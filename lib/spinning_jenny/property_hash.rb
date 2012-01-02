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

    def to_hash
      @internal_hash
    end
  end
end

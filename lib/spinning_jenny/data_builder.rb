require 'spinning_jenny/blueprint'
require 'spinning_jenny/property_hash'

module SpinningJenny
  class DataBuilder

    attr_reader :blueprint, :values, :properties_to_ignore

    def initialize(blueprint, values = {}, properties_to_ignore = [])
      @blueprint = blueprint

      @values = values
      @values = PropertyHash.from_hash(@values) if @values.kind_of?(Hash)

      @properties_to_ignore = properties_to_ignore.dup
    end

    def instantiate
      object = blueprint.describing_class.new
      object_values.each do |key, value|
        object.send("#{key}=", value)
      end
      object
    end

    def build
      instantiate
    end

    def create
      object = instantiate
      object.save
      object
    end

    def with(values)
      self.class.new blueprint, self.values.to_hash.merge(values)
    end

    def without(*properties)
      self.class.new blueprint, values, (self.properties_to_ignore + properties)
    end

    def object_values
      merged_values = blueprint.default_values.to_hash
      merged_values.merge! values.to_hash
      merged_values.reject! { |key, value| properties_to_ignore.include?(key.to_s) || properties_to_ignore.include?(key.to_sym) }

      merged_values.each do |key, value|
        if value.kind_of?(DataBuilder)
          merged_values[key] = value.build
        elsif value.respond_to? :call
          merged_values[key] = value.call
        end
      end

      merged_values
    end

  end
end

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
      calculated_object_values.each do |key, value|
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
      self.class.new blueprint, self.values.merge(values)
    end

    def without(*properties)
      self.class.new blueprint, values, (self.properties_to_ignore + properties)
    end

    def raw_object_values
      merged_values = blueprint.default_values.merge(values)
      merged_values.reject! properties_to_ignore
      merged_values
    end

    def calculated_object_values
      calculated_values = raw_object_values.to_hash
      calculated_values.each do |key, value|
        if value.kind_of? DataBuilder
          calculated_values[key] = value.build
        elsif value.respond_to? :call
          calculated_values[key] = value.call
        end
      end
    end

  end
end

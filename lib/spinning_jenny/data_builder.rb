require 'spinning_jenny/blueprint'

module SpinningJenny
  class DataBuilder

    attr_reader :blueprint, :values, :properties_to_ignore

    def initialize(blueprint, values = {}, properties_to_ignore = [])
      @blueprint = blueprint

      @values = {}
      values.keys.each do |key|
        @values[key.to_s] = values[key]
      end
      @values.freeze

      @properties_to_ignore = []
      properties_to_ignore.each do |property|
        @properties_to_ignore << property.to_s
      end
      @properties_to_ignore.freeze
    end

    def build
      object = blueprint.describing_class.new
      object_values.each do |key, value|
        object.send("#{key}=", value)
      end
      object
    end

    def with(values)
      self.class.new blueprint, self.values.merge(values)
    end

    def without(*properties)
      self.class.new blueprint, values, (self.properties_to_ignore + properties)
    end

    def object_values
      merged_values = blueprint.default_values.merge(values)
      merged_values.keys.each do |key|
        merged_values[key.to_s] = merged_values.delete(key)
      end
      merged_values.reject! { |key, value| properties_to_ignore.include? key }
      merged_values
    end

  end
end

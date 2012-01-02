require 'spinning_jenny/blueprint'

module SpinningJenny
  class DataBuilder

    attr_reader :blueprint, :values

    def initialize(blueprint, values = {})
      @blueprint = blueprint
      @values = values
    end

    def build
      object = blueprint.describing_class.new
      blueprint.default_values.each do |key, value|
        object.send("#{key}=", value)
      end
      object
    end

    def with(values)
      self.class.new blueprint, self.values.merge(values)
    end

    def object_values
      merged_values = blueprint.default_values.merge(values)
      merged_values.keys.each do |key|
        merged_values[key.to_s] = merged_values.delete(key)
      end
      merged_values
    end

  end
end

require 'spinning_jenny/blueprint'

module SpinningJenny
  class DataBuilder

    attr_reader :blueprint

    def initialize(blueprint)
      @blueprint = blueprint
    end

    def build
      object = blueprint.describing_class.new
      blueprint.default_values.each do |key, value|
        object.send("#{key}=", value)
      end
      object
    end

  end
end

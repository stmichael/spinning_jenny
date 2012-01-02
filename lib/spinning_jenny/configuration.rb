require 'spinning_jenny/blueprint'

module SpinningJenny
  class Configuration
    attr_reader :blueprints
    attr_accessor :object_creation_strategy

    def initialize
      @blueprints = {}
      @object_creation_strategy = :setter
    end

    def named_blueprint(name)
      blueprints[name.to_s]
    end

    def create_blueprint(name, describing_class, properties = {})
      blueprint = SpinningJenny::Blueprint.new(describing_class)
      properties.each do |key, value|
        blueprint.send("#{key}=", value)
      end
      blueprints[name.to_s] = blueprint
    end

    def clear_blueprints
      blueprints.clear
    end
  end
end

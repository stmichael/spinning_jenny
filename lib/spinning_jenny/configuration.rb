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

    def create_blueprint(name, describing_class)
      blueprints[name.to_s] = SpinningJenny::Blueprint.new(describing_class)
    end

    def clear_blueprints
      blueprints.clear
    end
  end
end

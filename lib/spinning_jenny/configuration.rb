require 'spinning_jenny/blueprint'

module SpinningJenny
  class Configuration
    attr_reader :blueprints

    def initialize
      @blueprints = {}
    end

    def named_blueprint(name)
      blueprints[name]
    end

    def create_blueprint(name, describing_class)
      blueprints[name] = SpinningJenny::Blueprint.new(describing_class)
    end

    def clear_blueprints
      blueprints.clear
    end
  end
end

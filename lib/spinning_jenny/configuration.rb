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

    def create_blueprint(describing_class)
      name = class_name_to_real_name(describing_class.name)

      blueprints[name] = SpinningJenny::Blueprint.new(describing_class)
    end

    def clear_blueprints
      blueprints.clear
    end

    def class_name_to_real_name(class_name)
      name = class_name.to_s.dup
      name.gsub!(/::/, '/')
      name.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      name.tr!("-", "_")
      name.downcase!
      name
    end
  end
end

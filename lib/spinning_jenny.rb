require "spinning_jenny/version"
require "spinning_jenny/blueprint"
require "spinning_jenny/data_builder"

module SpinningJenny

  def self.blueprint(sample_class)
    name = class_name_to_real_name(sample_class.name)

    yield named_blueprint(name) || create_blueprint(sample_class)
  end

  def self.builder_for(sample_class)
    name = class_name_to_real_name(sample_class.name)

    DataBuilder.new named_blueprint(name)
  end

  private

  class << self
    attr_reader :blueprints

    def class_name_to_real_name(class_name)
      name = class_name.to_s.dup
      name.gsub!(/::/, '/')
      name.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      name.tr!("-", "_")
      name.downcase!
      name
    end

    def named_blueprint(name)
      @blueprints ||= {}
      blueprints[name]
    end

    def create_blueprint(describing_class)
      name = class_name_to_real_name(describing_class.name)

      @blueprints ||= {}
      blueprints[name] = SpinningJenny::Blueprint.new(describing_class)
    end

    def clear_blueprints
      @blueprints ||= {}
      blueprints.clear
    end

  end

end

require "spinning_jenny/version"
require "spinning_jenny/blueprint"
require "spinning_jenny/data_builder"
require "spinning_jenny/configuration"

module SpinningJenny

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.blueprint(sample_class, properties = {})
    name = properties[:name] || class_name_to_real_name(sample_class.name)

    yield configuration.named_blueprint(name) || configuration.create_blueprint(name, sample_class)
  end

  def self.builder_for(class_or_name)
    name = case class_or_name
           when Class then class_name_to_real_name(class_or_name.name)
           else class_or_name
           end

    DataBuilder.new configuration.named_blueprint(name)
  end

  private

  def self.class_name_to_real_name(class_name)
    name = class_name.to_s.dup
    name.gsub!(/::/, '/')
    name.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    name.tr!("-", "_")
    name.downcase!
    name
  end

end

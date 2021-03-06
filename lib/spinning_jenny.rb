require "spinning_jenny/version"
require "spinning_jenny/blueprint"
require "spinning_jenny/data_builder"
require "spinning_jenny/configuration"

module SpinningJenny

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.blueprint(class_or_name, properties = {})
    sample_class = case class_or_name
                   when String, Symbol then Object.const_get(real_name_to_class_name(class_or_name))
                   else class_or_name
                   end
    name = properties.delete(:name) || class_name_to_real_name(sample_class.name)

    blueprint = configuration.named_blueprint(name) || configuration.create_blueprint(name, sample_class)
    yield blueprint if block_given?
    blueprint
  end

  def self.builder_for(class_or_name)
    name = class_or_name
    name = class_name_to_real_name(name) if name.kind_of?(Class)

    DataBuilder.new configuration.named_blueprint(name)
  end

  def self.method_missing(name, *args, &block)
    if match = name.to_s.match(/^(?:a|an)_(.*)$/)
      builder_for(match[1]) || super
    else
      super
    end
  end

  private

  def self.class_name_to_real_name(class_name)
    name = class_name.to_s.dup
    name.gsub!(/::/, '_')
    name.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    name.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    name.tr!("-", "_")
    name.downcase!
    name
  end

  def self.real_name_to_class_name(real_name)
    string = real_name.to_s
    string = string.sub(/^[a-z\d]*/) { $&.capitalize }
    string.gsub(/(?:_|(\/))([a-z\d]*)/i) { "#{$1}#{$2.capitalize}" }.gsub('/', '::')
  end

end

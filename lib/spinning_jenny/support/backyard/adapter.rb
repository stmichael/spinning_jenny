require 'backyard'
require 'spinning_jenny'

class Backyard::Adapter::SpinningJenny < Backyard::Adapter
  def class_for_type(model_type)
    blueprint = ::SpinningJenny.configuration.named_blueprint(model_type)
    raise ArgumentError, "no factory for: #{model_type}" unless blueprint
    blueprint.describing_class
  end

  def create(model_type, attributes)
    ::SpinningJenny.builder_for(model_type).with(attributes).create
  end
end

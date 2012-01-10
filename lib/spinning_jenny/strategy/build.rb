require 'spinning_jenny/strategy/base'

module SpinningJenny
  module Strategy
    class Build < Base
      def execute(class_to_instantiate, properties = {})
        object = instantiate(class_to_instantiate)
        set_properties object, properties
        object
      end

      def set_properties(object, properties = {})
        properties.each do |key, value|
          object.send "#{key}=", value
        end
      end
    end
  end
end

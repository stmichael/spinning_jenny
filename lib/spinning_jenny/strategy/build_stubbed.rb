require 'spinning_jenny/strategy/base'

module SpinningJenny
  module Strategy
    class BuildStubbed < Base
      def execute(class_to_instantiate, properties = {})
        object = instantiate(class_to_instantiate)
        stub_properties object, properties
        object
      end

      def stub_properties(object, properties = {})
        properties.each do |key, value|
          object.define_singleton_method key do
            value
          end
        end
      end
    end
  end
end

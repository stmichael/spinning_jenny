require 'spinning_jenny/strategy/build'

module SpinningJenny
  module Strategy
    class Create < Build
      def execute(class_to_instantiate, properties = {})
        object = super
        persist_object object
        object
      end

      def persist_object(object)
        object.save
      end
    end
  end
end

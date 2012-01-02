module SpinningJenny
  module ObjectCreation
    module Setter
      def self.instantiate(class_to_instantiate, values = {})
        object = class_to_instantiate.new
        values.each do |key, value|
          object.send("#{key}=", value)
        end
        object
      end
    end
  end
end

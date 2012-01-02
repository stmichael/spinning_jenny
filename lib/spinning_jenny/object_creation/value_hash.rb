module SpinningJenny
  module ObjectCreation
    module ValueHash
      def self.instantiate(class_to_instantiate, values = {})
        class_to_instantiate.new values
      end
    end
  end
end

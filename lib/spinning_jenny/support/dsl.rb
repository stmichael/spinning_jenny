require 'spinning_jenny'

module SpinningJenny
  module Support
    module DSL
      def build(class_name, attributes = {})
        SpinningJenny.builder_for(class_name).with(attributes).build
      end

      def create(class_name, attributes = {})
        SpinningJenny.builder_for(class_name).with(attributes).create
      end

      def build_stubbed(class_name, attributes = {})
        SpinningJenny.builder_for(class_name).with(attributes).build_stubbed
      end
    end
  end
end

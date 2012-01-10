module SpinningJenny
  module Strategy
    class Base
      def instantiate(a_class)
        a_class.new
      end
    end
  end
end

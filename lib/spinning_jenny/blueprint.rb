module SpinningJenny
  class Blueprint

    attr_reader :default_values, :describing_class

    def initialize(describing_class)
      @default_values = {}
      @describing_class = describing_class
    end

    def method_missing(name, *args, &block)
      if args.count == 1
        default_values[name.to_s] = args.first
      else
        super
      end
    end

  end
end

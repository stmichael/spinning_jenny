require 'spinning_jenny/property_hash'

module SpinningJenny
  class Blueprint

    attr_reader :default_values, :describing_class

    def initialize(describing_class)
      @default_values = PropertyHash.new
      @describing_class = describing_class
    end

    def method_missing(name, *args, &block)
      if args.count == 1
        default_values[name] = args.first
      elsif args.count == 0 && block_given?
        default_values[name] = block
      else
        super
      end
    end

  end
end

Dir[File.join(File.dirname(__FILE__), 'strategy', '*.rb')].each do |file|
  require file
end

module SpinningJenny
  module Strategy
    def self.by_name(name)
      strategy_class = Strategy.const_get name_to_class_name(name)
      strategy_class.new unless strategy_class.nil?
    end

    def self.exists?(name)
      Strategy.const_defined? name_to_class_name(name)
    end

    private

    def self.name_to_class_name(name)
      name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
    end
  end
end

Dir[File.join(File.dirname(__FILE__), 'object_creation', '*.rb')].each do |file|
  require file
end

module SpinningJenny
  module ObjectCreation
    def self.strategy(name)
      name = name.to_s.gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_)(.)/) { $1.upcase }
      ObjectCreation.const_get(name)
    end
  end
end

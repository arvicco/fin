module Orders
  # Represents business domain model for a single item (Order, Deal, Instrument, etc...)
  # currently it is only used to extract common functionality from record wrappers,
  # down the road it may be subclassed from ActiveModel
  class Model
    def self.prop_reader *args
      args.each do |arg|
        aliases = [arg].flatten
        name = aliases.shift
        instance_eval do
          attr_reader name
          aliases.each { |ali| alias_method "#{ali}", name }
        end
      end
    end

    def self.prop_accessor *args
      args.each do |arg|
        aliases = [arg].flatten
        name = aliases.shift
        instance_eval do
          attr_accessor name
          aliases.each do |ali|
            alias_method "#{ali}", name
            alias_method "#{ali}=", "#{name}="
          end
        end
      end
    end

    def initialize opts = {}
      opts.each { |key, value| send "#{key}=", value }
    end

    def index
      object_id
    end
  end
end

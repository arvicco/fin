module Fin
  # Represents business domain model for a single item (Quote, Deal, Instrument, etc...)
  # Currently it is only used to extract common functionality from record wrappers,
  # down the road the goal is to add ActiveModel compatibility
  class Model

    include Enumerable

    def self.attribute_types
      @attribute_types ||= superclass.attribute_types.dup rescue {}
    end

    def self.property prop_hash
      prop_hash.each do |arg, type|
        aliases = [arg].flatten
        name = aliases.shift
        instance_eval do

          attribute_types[name.to_s] = type.to_s

          define_method(name) do
            @attributes[name]
          end

          define_method("#{name}=") do |value|
            @attributes[name] = value
          end

          aliases.each do |ali|
            alias_method "#{ali}", name
            alias_method "#{ali}=", "#{name}="
          end
        end
      end

      # Using static calls, create class method extracting attributes from raw records
      attribute_extractor = attribute_types.map do |name, type|
        case type
          when /^[ct]/ # TODO: In future, read t AsLong and convert into DateTime
            ":#{name} => rec.GetValAsString('#{name}')"
          when /^i[14]/
            ":#{name} => rec.GetValAsLong('#{name}')"
          when /^i8opt/ # optional property
            ":#{name} => (val = rec.GetValAsString('#{name}'); val.to_i if val)"
          when /^i8/
            ":#{name} => rec.GetValAsString('#{name}').to_i"
          when /^[df].+?opt/ # optional property
            ":#{name} => (val = rec.GetValAsString('#{name}'); val.to_f if val)"
          when /^[df]/
            ":#{name} => rec.GetValAsString('#{name}').to_f"
          else
            raise "Unrecognized attribute type: #{name} => #{type}"
        end
      end.join(",\n")

      extractor_body = "def self.from_record(rec)
                          new( #{attribute_extractor} )
                        end"

#      puts "In #{self}:, #{extractor_body"
      instance_eval extractor_body

      to_msg_body = "def self.to_msg(rec)
                          { #{attribute_extractor} }
                        end"
      instance_eval to_msg_body
    end

    def initialize opts = {}
      @attributes = {}
      opts.each { |key, value| send "#{key}=", value }
    end

    def each
      if block_given?
        self.class.attribute_types.each { |name, _| yield name, send(name) }
      else
        self.class.attribute_types.map { |name, _| [name, send(name)].to_enum }
      end
    end

    alias each_property each

    def inspect divider=','
      map { |property, value| "#{property}=#{value}" }.join(divider)
    end

    # TODO: DRY principle: there should be one authoritative source for everything...
    # TODO: Should such source be schema file, or Model code?
    # TODO: Maybe, Model should just read from schema file at init time?

    # All P2 records carry these properties
    property [:replID, :repl_id] => :i8,
             [:replRev, :repl_rev, :rev] => :i8,
             [:replAct, :repl_act] => :i8

    def index
      object_id # TODO: @repl_id?
    end
  end
end

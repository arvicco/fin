module Fin
  # Represents business domain model for a single item (Quote, Deal, Instrument, etc...)
  # Currently it is only used to extract common functionality from record wrappers,
  # down the road the goal is to add ActiveModel compatibility
  class Model

    include Enumerable

    def self.attribute_types
      @attribute_types ||= (superclass.attribute_types.dup rescue {})
    end

    def self.model_class_id value = nil
      if value
        @model_class_id ||= value
        model_classes[@model_class_id] = self
      else
        @model_class_id
      end
    end

    def self.model_classes
      @model_classes ||= (superclass.model_classes rescue {}) #shared list for all subclasses
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
            "rec.GetValAsString('#{name}')"
          when /^i[14]/
            "rec.GetValAsLong('#{name}')"
          when /^i8/
            "rec.GetValAsString('#{name}').to_i"
          when /^[df]/
            "rec.GetValAsString('#{name}').to_f"
          else
            raise "Unrecognized attribute type: #{name} => #{type}"
        end
      end.join(",\n")

      extractor_body = "def self.extract_attributes rec
                          [#{attribute_extractor}]
                        end"

#      puts "In #{self}:, #{extractor_body"
      instance_eval extractor_body
    end

    def self.from_record rec
      new *extract_attributes(rec)
    end

    # Unpacks attributes into appropriate Model subclass
    def self.from_msg msg
      class_id = msg.first
      model_classes[class_id].new *msg[1..-1]
    end

    # Extracts attributes from record into a serializable format (Array)
    # Returns an Array where 1st element is a model_class_id of our Model subclass,
    # and second element is a list of arguments to its initialize. Class method!
    def self.to_msg rec
      extract_attributes(rec).unshift(model_class_id)
    end

    # Converts OBJECT attributes into a serializable format (Array)
    # Returns an Array where 1st element is a model_class_id of our Model subclass,
    # and second element is a list of arguments to its initialize. Instance method!
    def to_msg
      inject([self.class.model_class_id]) { |array, (name, _)| array << send(name) }
    end

    # TODO: Builder pattern, to avoid args Array creation on each initialize?
    def initialize *args
      @attributes = {}
      opts = args.last.is_a?(Hash) ? args.pop : {}
      each_with_index { |(name, _), i| send "#{name}=", args[i] } unless args.empty?
      opts.each { |name, value| send "#{name}=", value }
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

    # Fin::Model itself has model_class_id 0
    model_class_id 0
  end
end

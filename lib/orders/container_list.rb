require 'orders/indexed_list'

module Orders
  # Represents Container that holds Model objects (items) of only ONE specific type
  # TODO: In future, merge ChangedList and ContainerList to flatten class hierarchy
  class ContainerList < ChangedList

    attr_reader :item_type

    def initialize opts = {}
      @item_type = opts[:item_type]
      raise "Item type not given for #{self}" unless @item_type
      super()
    end

    def check item
      item.is_a?(@item_type) && item.index
    end

    def index item
      item.index if check item
    end

    def add_record rec
      add? @item_type.from_record(rec)
    end

    def remove_record rec, id
      index = @item_type.index_for rec
      remove? self[index]
    end
  end
end

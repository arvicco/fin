require 'fin/container_list'

module Fin
  # Represents Book (OrderBook, DealBook, etc...) for one security(isin)
  # It is used as additional index by BookedList subclass (OrderList, DealList)
  class Book < ContainerList

    attr_reader :isin_id
    alias isin isin_id

    def initialize opts = {}
      @isin_id = opts[:isin_id]
      @book_index = opts[:book_index]
      @book_condition = opts[:book_condition]
      raise "No isin_id given for #{self}" unless @isin_id
      super
    end

    # Validation of the item being included
    def check item
      if item.is_a?(@item_type) && item.isin_id == isin_id
        @book_condition ? @book_condition.call(item) : true
      else
        false
      end
    end

    def index item
      if @book_index
        @book_index.call(item)
      else
        super
      end
    end

    def add? item
      if super
        item.book = self
        item
      end
    end

    def remove? item
      if super
        item.book = nil
        item
      end
    end
  end
end

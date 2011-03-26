require 'orders/indexed_list'

module Orders
  # Represents Book (OrderBook, DealBook, etc...) for one security(isin)
  # It is used as additional index by BookedList subclass (OrderList, DealList)
  class Book < IndexedList

    attr_accessor :changed
    attr_reader :isin
    alias isin_id isin

    def initialize isin
      @isin = isin
      @changed = true
      super()
    end

    def add? item
      if super
        @changed = true # Marking Book as changed
        item.book = self
        item
      end
    end

    def remove? item
      if super
        @changed = true # Marking Book as changed
        item.book = nil
        item
      end
    end
  end
end

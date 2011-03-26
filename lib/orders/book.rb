require 'orders/changed_list'

module Orders
  # Represents Book (OrderBook, DealBook, etc...) for one security(isin)
  # It is used as additional index by BookedList subclass (OrderList, DealList)
  class Book < ChangedList

    attr_reader :isin_id
    alias isin isin_id

    def initialize isin_id
      @isin_id = isin_id
      super()
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

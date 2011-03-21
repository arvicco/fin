module Orders
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class OrderBook < IndexedList

    attr_accessor :changed
    attr_reader :isin_id
    alias isin isin_id

    def initialize isin_id
      @isin_id = isin_id
      @changed = true
      super()
    end

    def index item
      item.price
    end

    def check item
      item.price > 0
    end

    def add? item
      if super
        @changed = true # Marking DOM as changed
        item.order_book = self
        item
      end
    end

    def remove? item
      if super
        @changed = true # Marking DOM as changed
        item.order_book = nil
        item
      end
    end
  end
end

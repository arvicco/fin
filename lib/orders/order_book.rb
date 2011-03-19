module Orders
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class OrderBook < IndexedList

    attr_accessor :isin_id, :changed

    def initialize isin_id
      @isin_id = isin_id
      @changed = true
      super()
    end

    def index item
      item.price
    end

    def add item
      if item.price > 0
        @changed = true # Marking DOM as changed
        item.order_book = self
        super
      else
        self
      end
    end

    # Does not call super!
    def remove item
      @changed = true if delete index item # Marking DOM as changed
      item.order_book = nil
      self
    end
  end
end

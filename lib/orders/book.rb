module Orders
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class Book < IndexedList

    attr_accessor :changed
    attr_reader :isin_id
    alias isin isin_id

    def initialize isin_id
      @isin_id = isin_id
      @changed = true
      super()
    end

    def add? item
      if super
        @changed = true # Marking DOM as changed
        item.book = self
        item
      end
    end

    def remove? item
      if super
        @changed = true # Marking DOM as changed
        item.book = nil
        item
      end
    end
  end
end

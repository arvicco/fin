module OrderBook
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class OrderBook < IndexedList

    attr_accessor :isin_id, :changed

    def initialize isin_id
      @isin_id = isin_id
      @changed = true
      super
    end

  end
end

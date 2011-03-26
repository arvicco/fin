require 'orders/models/order'
require 'orders/book'

module Orders
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class OrderBook < Book

    def index item
      item.price
    end

    # Validation of the item being included
    def check item
      item.is_a?(Orders::Order) && item.isin == isin && item.price > 0
    end

  end
end

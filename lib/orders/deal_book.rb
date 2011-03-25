require 'orders/deal_item'
require 'orders/book'

module Orders
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class DealBook < Book

    def index item
      item.deal_id
    end

    # Validation of the item being included
    def check item
      item.is_a?(Orders::DealItem) && item.isin == isin
    end

  end
end

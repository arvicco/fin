require 'orders/deal_book'
require 'orders/booked_list'

module Orders
  # Represents list of ALL OrderItems, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists OrderItems by price.
  class DealList < BookedList
    attr_accessor :books

    def initialize
      super Orders::DealBook
    end

    def index item
      item.deal_id
    end
  end
end

require 'orders/deal_book'
require 'orders/booked_list'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class DealList < BookedList

    def initialize
      super Orders::DealBook
    end

    def index item
      item.deal_id
    end

    def check item
      item.is_a?(Orders::Deal) && item.deal_id
    end

    def add_record rec
      add? Deal.from_record(rec)
    end

    def remove_record rec, id
      index = Deal.index_for rec
      remove? self[index]
    end
  end
end


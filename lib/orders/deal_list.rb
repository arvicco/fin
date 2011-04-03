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
      add? Deal.new :isin_id => rec.GetValAsLong('isin_id'),
                    :deal_id => rec.GetValAsLong('id_deal'),
                    :id => rec.GetValAsString('replID').to_i,
                    :rev => rec.GetValAsString('replRev').to_i,
                    :price => rec.GetValAsString('price').to_f,
                    :moment => rec.GetValAsString('moment'),
                    :amount => rec.GetValAsString('amount').to_i
    end

    def remove_record rec, id
      remove? self[rec.GetValAsLong('id_deal')]
    end
  end
end


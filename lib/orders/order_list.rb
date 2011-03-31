require 'orders/order_book'
require 'orders/booked_list'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class OrderList < BookedList

    def initialize
      super Orders::OrderBook
    end

    def index item
      item.id
    end

    def add_record rec
      add? Order.new(:isin_id => rec.GetValAsLong('isin_id'),
                     :id => rec.GetValAsString('replID').to_i,
                     :rev => rec.GetValAsString('replRev').to_i,
                     :price => rec.GetValAsString('price').to_f,
                     :volume => rec.GetValAsString('volume').to_f,
                     :dir => rec.GetValAsLong('dir'))
    end

    def remove_record rec, id
      remove? self[id]
    end

  end
end

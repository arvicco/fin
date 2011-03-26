require 'orders/models/model'

module Orders
  # Represents single price level for OrderBook for one security
  # (aggregate bid or ask with aggregate volume)
  #      // элемент "строка в стакане"
  #      tOrderBookItem  = record
  #        id         : int64;
  #        rev        : int64;
  #        price         : double;  // цена
  #        volume        : double;  // кол-во
  #        buysell       : longint; // покупка(1)/продажа(2)
  #        order_book      : tOrderBook;
  class Order < Model
    # Properties as per P2ClientGate API
    prop_accessor :id, :rev,
                  [:isin_id, :isin],
                  :price, :volume,
                  [:dir, :buysell],
                  :moment

    attr_accessor :book

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{id}:#{price}>#{volume}#{dir == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end
end

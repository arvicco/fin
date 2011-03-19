module OrderBook
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
  class OrderBookItem
    attr_accessor :isin_id, :id, :rev, :price, :volume, :buysell, :order_book

    def initialize opts = {}
      opts.each {|key, value| send "#{key}=", value}
    end
  end
end

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

    def self.from_record rec
      new :isin_id => rec.GetValAsLong('isin_id'),
          :repl_id => rec.GetValAsString('replID').to_i,
          :repl_rev => rec.GetValAsString('replRev').to_i,
          :price => rec.GetValAsString('price').to_f,
          :volume => rec.GetValAsString('volume').to_f,
          :dir => rec.GetValAsLong('dir')
    end

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  [:isin_id, :isin],
                  :price, :volume,
                  [:dir, :buysell],
                  :moment

    attr_accessor :book

    def index
      @repl_id
    end

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{repl_id}:#{price}>#{volume}#{dir == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end
end

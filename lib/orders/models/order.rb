require 'orders/models/model'

module Orders
  class Order < Model

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  [:isin_id, :isin],
                  :price, #           d16.5 Цена котировки
                  :volume, #          i8	Объём агрегированной котировки
                  [:dir, :buysell], # i1	Направление котировки: покупка (1) /продажа (2)
                  :moment #           t	Время последнего обновления котировки

    attr_accessor :book

    def self.from_record rec
      new :isin_id => rec.GetValAsLong('isin_id'),
          :repl_id => rec.GetValAsString('replID').to_i,
          :repl_rev => rec.GetValAsString('replRev').to_i,
          :price => rec.GetValAsString('price').to_f,
          :volume => rec.GetValAsString('volume').to_f,
          :moment => rec.GetValAsString('moment'),
          :dir => rec.GetValAsLong('dir')
    end

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

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

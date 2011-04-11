require 'fin/models/model'

module Fin
  class Order < Model

    # Properties as per P2ClientGate API
    prop_accessor [:isin_id, :isin] => :i8,
                  :price => :'d16.5', #       Цена котировки
                  :volume => :i8, # 	        Объём агрегированной котировки
                  [:dir, :buysell] => :i1, #	Направление котировки: покупка (1) /продажа (2)
                  :moment => :t #          	  Время последнего обновления котировки

    attr_accessor :book

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

    def index
      repl_id
    end

    def price_as_integer
      price.round == price ? price.to_i : price
    end

    def inspect
      "#{repl_id}:#{price_as_integer}>#{volume}#{dir == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end
end

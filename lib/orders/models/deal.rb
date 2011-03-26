require 'orders/models/model'

module Orders
  # Represents a single deal (trade) for one security
  # Source table: FORTS_FUTTRADE_REPL::deal – cделки
  #
  class Deal < Model
    # Properties as per P2ClientGate API
    prop_accessor :id, :rev,
                  [:isin_id, :isin],
                  :price,
                  :amount,
                  [:deal_id, :deal, :id_deal],
                  [:sess_id, :sess, :session, :session_id],
                  :moment,
                  :status_sell,
                  :status_buy,
                  :id_ord_sell,
                  :id_ord_buy,
                  :pos, # Кол-во позиций по инструменту на рынке после сделки.
                  :nosystem, # 1-внесистемная сделка, 0-обычная
                  [:repo_id, :repo, :id_repo], # Номер другой части сделки РЕПО
                  :id_deal_multileg # Номер сделки по связке

    attr_accessor :book

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{moment}:#{id}[#{isin}] #{price}>#{amount}"
    end

    alias to_s inspect
  end
end

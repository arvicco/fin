require 'fin/models/model'

module Fin
  # Represents a single deal (trade) for one security
  # Source table: FORTS_FUTTRADE_REPL::deal – cделки
  #
  class Deal < Model

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  [:isin_id, :isin], #   i4	Уникальный числовой идентификатор инструмента
                  :price, #    price	d16.5	Цена
                  :amount, #    amount	i4	Объем, кол-во единиц инструмента
                  [:deal_id, :id_deal], #    id_deal	i8	Номер сделки
                  [:sess_id, :session_id], #    sess_id	i4	Идентификатор сессии
                  :moment, #    moment	t	Время заключения сделки.
                  :pos, #  i4	Кол-во позиций по инструменту на рынке после сделки.
                  :nosystem, # 	i1	1-внесистемная сделка, 0-обычная
                  [:repo_id, :repo, :id_repo], # 	i8	Номер другой части сделки РЕПО
                  :id_deal_multileg # 	i8	Номер сделки по связке

    # Эти поля заполняются только для своих сделок:
    prop_accessor :code_sell, #	c7	Код продавца:status_sell,
                  :id_ord_sell, # 	i8	Номер заявки продавца
                  :ext_id_sell, # 	i4	Внешний номер из заявки продавца
                  :comment_sell, # 	c20	Комментарий из заявки продавца.
                  :trust_sell, # 	i1	Признак ДУ (доверительного управления) из заявки продавца
                  :status_sell, # 	i4	Статус сделки со стороны продавца
                  :hedge_sell, # 	i1	Признак хеджевой сделки со стороны продавца
                  :fee_sell, # 	d26.2	Сбор по сделке продавца
                  :login_sell, # 	c20	Логин пользователя продавца
                  :code_rts_sell, # 	c7	Код РТС продавца
                  :code_buy, # 	c7	Код покупателя
                  :id_ord_buy, # 	i8	Номер заявки покупателя.
                  :ext_id_buy, # 	i4	Внешний номер из заявки покупателя
                  :comment_buy, # 	c20	Комментарий из заявки покупателя
                  :trust_buy, # 	i1	Признак ДУ (доверительного управления) из заявки покупателя
                  :status_buy, # 	i4	Статус сделки со стороны покупателя
                  :hedge_buy, # 	i1	Признак хеджевой сделки со стороны покупателя
                  :fee_buy, # 	d26.2	Сбор по сделке покупателя
                  :login_buy, # 	c20	Логин пользователя покупателя
                  :code_rts_buy # 	c7	Код РТС покупателя

    attr_accessor :book

    def self.from_record rec
      new :isin_id => rec.GetValAsLong('isin_id'),
          :deal_id => rec.GetValAsLong('id_deal'),
          :id => rec.GetValAsString('replID').to_i,
          :rev => rec.GetValAsString('replRev').to_i,
          :price => rec.GetValAsString('price').to_f,
          :moment => rec.GetValAsString('moment'),
          :amount => rec.GetValAsString('amount').to_i
    end

    def self.index_for rec
      rec.GetValAsLong('id_deal')
    end

    def index
      @deal_id
    end

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

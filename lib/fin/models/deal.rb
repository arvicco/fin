require 'fin/models/model'

module Fin
  # Represents a single deal (trade) for one security
  # Source table: FORTS_FUTTRADE_REPL::deal – cделки
  #
  class Deal < Model

    # Properties as per P2ClientGate API
    prop_accessor [:isin_id, :isin] => :i4, #        Уникальный числовой идент. инструмента
                  :price => :'d16.5', #              Цена
                  :amount => :i4, #                  Объем, кол-во единиц инструмента
                  [:id_deal, :deal_id] => :i8, #     Номер сделки
                  [:sess_id, :session_id] => :i4, #  Идентификатор сессии
                  :moment => :t, #     Время заключения сделки.
                  :pos => :i4, #       Кол-во позиций по инструменту на рынке после сделки.
                  :nosystem => :i1, #  1-внесистемная сделка, 0-обычная
                  [:id_repo, :repo_id, :repo] => :i8, #  Номер другой части сделки РЕПО
                  :id_deal_multileg => :i8 # 		         Номер сделки по связке

    # Эти поля заполняются только для своих сделок:
    prop_accessor :code_sell => :c7, #     Код продавца:status_sell,
                  :id_ord_sell => :i8, #   Номер заявки продавца
                  :ext_id_sell => :i4, #   Внешний номер из заявки продавца
                  :comment_sell => :c20, # Комментарий из заявки продавца.
                  :trust_sell => :i1, #    Признак доверительного управления из заявки продавца
                  :status_sell => :i4, #   Статус сделки со стороны продавца
                  :hedge_sell => :i1, #    Признак хеджевой сделки со стороны продавца
                  :fee_sell => :'d26.2', # Сбор по сделке продавца
                  :login_sell => :c20, #   Логин пользователя продавца
                  :code_rts_sell => :c7, # Код РТС продавца
                  :code_buy => :c7, #      Код покупателя
                  :id_ord_buy => :i8, #    Номер заявки покупателя.
                  :ext_id_buy => :i4, #    Внешний номер из заявки покупателя
                  :comment_buy => :c20, #  Комментарий из заявки покупателя
                  :trust_buy => :i1, #     Признак доверительного управления из заявки покупателя
                  :status_buy => :i4, #    Статус сделки со стороны покупателя
                  :hedge_buy => :i1, #     Признак хеджевой сделки со стороны покупателя
                  :fee_buy => :'d26.2', #  Сбор по сделке покупателя
                  :login_buy => :c20, #    Логин пользователя покупателя
                  :code_rts_buy => :c7 # 	 Код РТС покупателя

    attr_accessor :book

    def self.index_for rec
      rec.GetValAsLong('id_deal')
    end

    def index
      deal_id
    end

    def price_as_integer
      price.round == price ? price.to_i : price
    end

    def inspect
      "#{moment}:#{repl_id}[#{isin}] #{price}>#{amount}"
    end

    alias to_s inspect
  end
end

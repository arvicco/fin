require 'orders/models/model'

module Orders
  # Represents information about one tradeable security
  # Source table: FORTS_FUTINFO_REPL::fut_sess_contents
  #
  class Instrument < Model

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  [:sess_id, :sess, :session, :session_id], # i4	Номер сессии.
                  :isin_id, #       i4	Уникальный числовой код инструмента.
                  :isin, #          c25	Символьный код инструмента
                  :short_isin, #    c25	Описатель инструмента.
                  :name, #          c75	Наименование инструмента.
                  :inst_term, #     i4	Смещение от спота.
                  :code_vcb, #  	  c25	Код контракта.
        # Not extracted from record yet...
                  :is_limited, #    i1	Признак наличия лимитов в торгах.
                  :limit_up, #      d16.5	Верхний лимит цены.
                  :limit_down, #    d16.5	Нижний лимит цены.
                  :old_kotir, #     d16.5	Скорректированная расчетная цена предыдущей сессии.
                  :buy_deposit, #   d16.2	ГО покупателя.
                  :sell_deposit, #  d16.2	ГО продавца.
                  :roundto, #       i4	Количество знаков после запятой в цене.
                  :min_step, #      d16.5	Минимальный шаг цены.
                  :step_price, #    d16.5	Стоимость шага цены.
                  :d_pg, #          t	Дата окончания обращения инструмента.
                  :is_spread, #     i1	Признак вхождения фьючерса в межмесячный спрэд.
                  #                    1 – входит; 0 – не входит.
                  :coeff, #         d9.6	Коэффициент межмесячного спрэда.
                  :d_exp, #         t	Дата исполнения инструмента.
                  :is_percent, #    i1	Признак того, что фьючерс торгуется в процентах.
                  #                    1 - торгуется процентах, 0 – торгуется не в процентах
                  :percent_rate, #  d6.2	Процентная ставка для расчета вариационной маржи
                  #                       по процентным фьючерсам.
                  :last_cl_quote, # d16.5	Котировка после последнего клиринга.
                  :signs, #         i4	Поле признаков.
                  :is_trade_evening, # i1	Признак торговли в вечернюю сессию.
                  :ticker, #        i4	Уникальный числовой код Главного Спота.
                  :state, #         i4	Состояние торговли по инструменту
                  :price_dir, #     i1	Направление цены инструмента
                  :multileg_type, #	i1	Тип связки
                  :legs_qty, #      i4	Количество инструментов в связке
                  :step_price_clr, #      d16.5	Cтоимость шага цены вечернего клиринга
                  :step_price_interclr, # d16.5	Стоимость шага цены пром. клиринга
                  :step_price_curr #      d16.5	Стоимость минимального шага цены, выраженная в валюте

    def self.from_record rec
      new :isin_id => rec.GetValAsLong('isin_id'),
          :isin => rec.GetValAsString('isin'),
          :short_isin => rec.GetValAsString('short_isin'),
          :name => rec.GetValAsString('name'),
          :inst_term => rec.GetValAsLong('inst_term'),
          :code_vcb => rec.GetValAsString('code_vcb'),

    end

    def self.index_for rec
      rec.GetValAsLong('isin_id')
    end

    def index
      @isin_id
    end

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{name}:#{short_isin}[#{isin}]"
    end

    alias to_s inspect
  end
end

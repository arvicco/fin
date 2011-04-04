require 'orders/models/model'

module Orders
  # Represents information about client`s money, vm and various limits
  # Source table: FORTS_ PART_REPL::part – информация о средствах и лимитах
  #
  class MoneyLimit < Model
    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  :client_code, # 	  c7	Код клиента
                  :money_old, # 	    d26.2	Денег на начало сессии
                  :money_amount, # 	  d26.2	Всего денег
                  :money_free, # 	    d26.2	Свободно денег
                  :money_blocked, # 	d26.2	Заблокировано денег
                  :pledge_old, # 	    d26.2	Залогов на начало сессии
                  :pledge_amount, # 	d26.2	Всего залогов
                  :pledge_free, # 	  d26.2	Свободно залогов
                  :pledge_blocked, # 	d26.2	Заблокировано залогов
                  :vm_reserve, # 	    d26.2	Сумма, зарезервированная под вариационную маржу
                  :vm_intercl, # 	    d26.2	Mаржа, списанная или полученная в пром. клиринг
                  :fee, # 	          d26.2	Списанный сбор
                  :fee_reserve, # 	  d26.2	Заблокированный резерв сбора под заявки
                  :limit_spot_buy, # 	d26.2	Лимит на Покупку Спотов.
                  :limit_spot_buy_used, # 	d26.2	Использованный Лимит на Покупку Спотов
                  :coeff_go, # 	      d16.5	Коэффициент клиентского ГО
                  :coeff_liquidity, # d16.5	Коэффициент ликвидности
                  :is_auto_update_limit, # 	    i1 Признак автокоррекции лимита на величину
                  #  дохода при закачке после клиринга: 0-нет, 1-менять.
                  :is_auto_update_spot_limit, # i1	Признак автокоррекции лимитов по Спотам
                  # (на Продажу, и на Покупку) при закачке после клиринга: 0-нет, 1-менять.
                  :no_fut_discount, # 	        i1	Запрещение использования скидки по
                  # фьючерсам: 1-Запрет, 0-нет.
                  :limits_set, # 	              i1	Признак лимитов. 0 – лимиты отсутствуют
                  :premium, # 	                d26.2	Премия
                  :premium_order_reserve # 	    f	Резерв премии под заявки

    def self.from_record rec
      new :repl_id => rec.GetValAsString('replID').to_i,
          :repl_rev => rec.GetValAsString('replRev').to_i,
          :client_code => rec.GetValAsString('client_code'),
          :money_old => rec.GetValAsString('money_old').to_f,
          :money_amount => rec.GetValAsString('money_amount').to_f,
          :money_free => rec.GetValAsString('money_free').to_f,
          :money_blocked => rec.GetValAsString('money_blocked').to_f,
          :pledge_old => rec.GetValAsString('pledge_old').to_f,
          :pledge_amount => rec.GetValAsString('pledge_amount').to_f,
          :pledge_free => rec.GetValAsString('pledge_free').to_f,
          :pledge_blocked => rec.GetValAsString('pledge_blocked').to_f,
          :vm_reserve => rec.GetValAsString('vm_reserve').to_f,
          :vm_intercl => rec.GetValAsString('vm_intercl').to_f,
          :fee => rec.GetValAsString('vm_intercl').to_f,
          :fee_reserve => rec.GetValAsString('vm_reserve').to_f,
          :limit_spot_buy => rec.GetValAsString('vm_reserve').to_f,
          :limit_spot_buy_used => rec.GetValAsString('vm_reserve').to_f,
    end

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

    def index
      @repl_id
    end

    def inspect
      "Money: Old #{money_old} Amt #{money_amount} Free #{money_free} Blck #{money_blocked} " +
          "Pledge: Old #{pledge_old} Amt #{pledge_amount} Free #{pledge_free} Blck #{pledge_blocked} " +
          "VM: Reserve #{vm_reserve} Intercl #{vm_intercl} Fee: #{fee} Reserve #{fee_reserve} " +
          "Limit Spot: Buy #{limit_spot_buy} Used #{limit_spot_buy_used}"
    end

    alias to_s inspect
  end
end

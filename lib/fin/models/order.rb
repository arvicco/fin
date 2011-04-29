require 'fin/models/model'

module Fin

  # Source table: 	FORTS_FUTTRADE_REPL::orders_log - журнала изменений заявок и сделок.
  # Each record in this table represents an action related to some client Order:
  # - Order added, Order deleted, Order (partially) executed...
  #
  # In principle, you can construct/update NOT only Orders, but also Deals and Quotes
  # from information arriving via (full) 'orders_log' table...
  #
  class Order < Model
    model_class_id 14

    # Properties as per P2ClientGate API
    property [:id_ord, :order_id] => :i8, # 	 Номер заявки
             [:sess_id, :session_id] => :i4, # Идентификатор сессии
             :client_code => :c7, # 	  Код клиента
             :moment => :t, # 	        Время изменения состояния заявки
             :isin_id => :i4, # 	      Уникальный числовой идентификатор инструмента
             :dir => :i1, # 	          Направление, 1 – покупка, 2 – продажа
             :price => :'d16.5', # 	    Цена (заявки)
             :amount => :i4, # 	        Количество в операции
             :amount_rest => :i4, # 	  Оставшееся количество в заявке
             :comment => :c20, # 	      Комментарий трейдера
             :hedge => :i1, # 	        Признак хеджевой заявки (1 / 0)
             :trust => :i1, # 	        Признак заявки доверительного управления (1 / 0)
             :login_from => :c20, # 	  Логин пользователя, поставившего заявку
             :broker_to => :c7, # 	    Код FORTS фирмы-адресата внесистемной заявки
             :broker_to_rts => :c7, # 	Код RTS фирмы-адресата внесистемной заявки
             :ext_id => :i4, # 	        Внешний номер. Добавляется в заявку, сделку
             :date_exp => :t, # 	      Дата истечения заявки
             :id_ord1 => :i4, # 	      Номер первой заявки (при перестановке?)
             :broker_from_rts => :c7, # Код РТС фирмы  - владельца заявки
             :id_deal => :i8, # 	      Идентификатор сделки по данной записи журнала заявок
             :deal_price => :'d16.5', # Цена заключенной сделки
             :status => :i4, # 	        Статус заявки - Представляет собой битовую маску:
             #    o	0x01 – Котировочная
             #    o	0x02 – Встречная
             #    o	0x04 – Внесистемная
             #    o	0x100000 – Запись является результатом операции перемещения заявки
             #    o	0x200000 – Запись является результатом операции удаления заявки
             #    o	0x400000 – Запись является результатом группового удаления
             #    o	0x800000 – Признак удаления остатка заявки по причине кросс-сделки
             :action => :i1 # 	        Описывает действие, произошедшее с заявкой:
#                 o	0 – Заявка удалена
#                 o	1 – Заявка добавлена
#                 o	2 – Заявка сведена в сделку

#    def self.index_for rec
#      rec.GetValAsLong('replID')
#    end

    def index
      repl_id
    end

    def to_s
      "#{repl_id}:#{price_as_integer}>#{amount}#{dir == 1 ? '+' : '-'}"
    end

    def price_as_integer
      if price && price.round == price
        price.to_i
      else
        price
      end
    end
  end
end

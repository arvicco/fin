require 'fin/models/model'

module Fin
  # Represents a client`s position for one security
  # Source table: FORTS_POS_REPL::position
  #
  class Position < Model
    model_class_id 15

    # Properties as per P2ClientGate API
    property :isin_id => :i4, #        Уникальный числовой идентификатор инструмента
             :client_code => :c7, #    Код клиента
             :open_qty => :i4, #       Количество позиций на начало сессии
             :buys_qty => :i4, #       Количество купленных контрактов в ходе сессии
             :sells_qty => :i4, #      Количество проданных контрактов в ходе сессии
             :pos => :i4, #            Текущая позиция
             :net_volume_rur => :'d26.2',
             #     Hетто-сумма денег, в рублях, на которую были совершены сделки.
             #     Положительное число – деньги приходят, отрицательное – деньги выплачиваются
             :last_deal_id => :i8 #    Идентификатор последней сделки

    def self.index_for rec
      rec.GetValAsLong('isin_id')
    end

    def index
      isin_id
    end

    def to_s
      "#{repl_id}[#{isin_id}] #{pos}, open: #{open_qty}, buys: #{buys_qty}, sells: #{sells_qty}"
    end
  end
end

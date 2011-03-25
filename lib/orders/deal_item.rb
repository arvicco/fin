require 'orders/indexed_list'

module Orders
  # Represents single deal for one security
  class DealItem
    # Properties
    attr_accessor :id, :rev, :isin_id, :price, :amount,
                  :deal_id,
                  :sess_id,
                  :moment,
                  :status_sell,
                  :status_buy,
                  :id_ord_sell,
                  :id_ord_buy,
                  :pos, # Кол-во позиций по инструменту на рынке после сделки.
                  :nosystem, # 1-внесистемная сделка, 0-обычная
                  :repo_id, # Номер другой части сделки РЕПО
                  :id_deal_multileg # Номер сделки по связке

    alias volume amount
    alias volume= amount=
    alias isin isin_id
    alias isin= isin_id=
    alias deal deal_id
    alias deal= deal_id=
    alias sess sess_id
    alias sess= sess_id=
    alias id_repo repo_id
    alias id_repo= repo_id=

    attr_accessor :book

    def initialize opts = {}
      opts.each { |key, value| send "#{key}=", value }
    end

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{moment}:#{id}[#{isin}] #{price}>#{volume}"
    end

    alias to_s inspect
  end
end

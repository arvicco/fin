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
                  :pos, # ���-�� ������� �� ����������� �� ����� ����� ������.
                  :nosystem, # 1-������������ ������, 0-�������
                  :repo_id, # ����� ������ ����� ������ ����
                  :id_deal_multileg # ����� ������ �� ������

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

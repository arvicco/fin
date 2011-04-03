require 'orders/models/model'

module Orders
  # Represents a single deal (trade) for one security
  # Source table: FORTS_FUTTRADE_REPL::deal � c�����
  #
  class Deal < Model

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

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
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
                  :pos, # ���-�� ������� �� ����������� �� ����� ����� ������.
                  :nosystem, # 1-������������ ������, 0-�������
                  [:repo_id, :repo, :id_repo], # ����� ������ ����� ������ ����
                  :id_deal_multileg # ����� ������ �� ������

    attr_accessor :book

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

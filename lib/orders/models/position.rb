require 'orders/models/model'

module Orders
  # Represents a client`s position for one security
  # Source table: FORTS_POS_REPL::position
  #
  class Position < Model

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  [:isin_id, :isin],
                  :client_code,
                  :open_qty,
                  :buys_qty,
                  :sells_qty,
                  :pos,
                  :net_volume_rur,
                  :last_deal_id
    #    isin_id	    i4	���������� �������� ������������� �����������
    #    client_code	c7	��� �������
    #    open_qty	    i4	���������� ������� �� ������ ������
    #    buys_qty	    i4	���������� ��������� ���������� � ���� ������
    #    sells_qty	  i4	���������� ��������� ���������� � ���� ������
    #    pos	        i4	������� �������
    #    net_volume_rur	d26.2
    #         H����-����� �����, � ������, �� ������� ���� ��������� ������.
    #         ������������� ����� � ������ ��������, ������������� � ������ �������������
    #    last_deal_id	  i8	������������� ��������� ������

    def self.from_record rec
      new :isin_id => rec.GetValAsLong('isin_id'),
          :repl_id => rec.GetValAsString('replID').to_i,
          :repl_rev => rec.GetValAsString('replRev').to_i,
          :client_code => rec.GetValAsString('client_code'),
          :open_qty => rec.GetValAsLong('open_qty'),
          :buys_qty => rec.GetValAsLong('buys_qty'),
          :sells_qty => rec.GetValAsLong('sells_qty'),
          :pos => rec.GetValAsLong('pos'),
          :last_deal_id => rec.GetValAsLong('last_deal_id'),
          :net_volume_rur => rec.GetValAsString('net_volume_rur').to_f
    end

    def self.index_for rec
      rec.GetValAsLong('isin_id')
    end

    def index
      @isin_id
    end

    def inspect
      "#{repl_id}[#{isin_id}] #{pos}, open: #{open_qty}, buys: #{buys_qty}, sells: #{sells_qty}"
    end

    alias to_s inspect
  end
end

require 'orders/models/model'

module Orders
  # Represents information about one tradeable security
  # Source table: FORTS_FUTINFO_REPL::fut_sess_contents
  #
  class Instrument < Model

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  [:sess_id, :sess, :session, :session_id], # i4	����� ������.
                  :isin_id, #       i4	���������� �������� ��� �����������.
                  :isin, #          c25	���������� ��� �����������
                  :short_isin, #    c25	��������� �����������.
                  :name, #          c75	������������ �����������.
                  :inst_term, #     i4	�������� �� �����.
                  :code_vcb, #  	  c25	��� ���������.
        # Not extracted from record yet...
                  :is_limited, #    i1	������� ������� ������� � ������.
                  :limit_up, #      d16.5	������� ����� ����.
                  :limit_down, #    d16.5	������ ����� ����.
                  :old_kotir, #     d16.5	����������������� ��������� ���� ���������� ������.
                  :buy_deposit, #   d16.2	�� ����������.
                  :sell_deposit, #  d16.2	�� ��������.
                  :roundto, #       i4	���������� ������ ����� ������� � ����.
                  :min_step, #      d16.5	����������� ��� ����.
                  :step_price, #    d16.5	��������� ���� ����.
                  :d_pg, #          t	���� ��������� ��������� �����������.
                  :is_spread, #     i1	������� ��������� �������� � ����������� �����.
                  #                    1 � ������; 0 � �� ������.
                  :coeff, #         d9.6	����������� ������������ ������.
                  :d_exp, #         t	���� ���������� �����������.
                  :is_percent, #    i1	������� ����, ��� ������� ��������� � ���������.
                  #                    1 - ��������� ���������, 0 � ��������� �� � ���������
                  :percent_rate, #  d6.2	���������� ������ ��� ������� ������������ �����
                  #                       �� ���������� ���������.
                  :last_cl_quote, # d16.5	��������� ����� ���������� ��������.
                  :signs, #         i4	���� ���������.
                  :is_trade_evening, # i1	������� �������� � �������� ������.
                  :ticker, #        i4	���������� �������� ��� �������� �����.
                  :state, #         i4	��������� �������� �� �����������
                  :price_dir, #     i1	����������� ���� �����������
                  :multileg_type, #	i1	��� ������
                  :legs_qty, #      i4	���������� ������������ � ������
                  :step_price_clr, #      d16.5	C�������� ���� ���� ��������� ��������
                  :step_price_interclr, # d16.5	��������� ���� ���� ����. ��������
                  :step_price_curr #      d16.5	��������� ������������ ���� ����, ���������� � ������

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

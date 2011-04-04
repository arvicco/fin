require 'orders/models/model'

module Orders
  # Represents information about client`s money, vm and various limits
  # Source table: FORTS_ PART_REPL::part � ���������� � ��������� � �������
  #
  class MoneyLimit < Model

    def self.from_record rec
      new :repl_id => rec.GetValAsString('replID').to_i,
          :repl_rev => rec.GetValAsString('replRev').to_i,
          :client_code => rec.GetValAsString('client_code'),
          :money_old => rec.GetValAsString('money_old').to_f,
          :money_amount => rec.GetValAsString('money_amount').to_f,
          :money_free => rec.GetValAsString('money_free').to_f,
          :pledge_blocked => rec.GetValAsString('pledge_blocked').to_f,
          :pledge_old => rec.GetValAsString('pledge_old').to_f,
          :pledge_amount => rec.GetValAsString('pledge_amount').to_f,
          :pledge_free => rec.GetValAsString('pledge_free').to_f,
          :pledge_blocked => rec.GetValAsString('pledge_blocked').to_f,
    end

    def self.index_for rec
      rec.GetValAsLong('isin_id')
    end

    # Properties as per P2ClientGate API
    prop_accessor [:repl_id, :id], [:repl_rev, :rev],
                  :client_code,
                  :money_old,
                  :money_amount,
                  :money_free,
                  :money_blocked,
                  :pledge_old,
                  :pledge_amount,
                  :pledge_free,
                  :pledge_blocked,
                  :vm_reserve,
                  :vm_intercl,
                  :fee,
                  :fee_reserve,
                  :limit_spot_buy,
                  :limit_spot_buy_used,
                  :coeff_go,
                  :coeff_liquidity,
                  :is_auto_update_limit,
                  :is_auto_update_spot_limit,
                  :no_fut_discount,
                  :limits_set,
                  :premium,
                  :premium_order_reserve
#    client_code	  c7	��� �������
#    money_old	    d26.2	����� �� ������ ������
#    money_amount	  d26.2	����� �����
#    money_free	    d26.2	�������� �����
#    money_blocked	d26.2	������������� �����
#
#    pledge_old	    d26.2	������� �� ������ ������
#    pledge_amount	d26.2	����� �������
#    pledge_free	  d26.2	�������� �������
#    pledge_blocked	d26.2	������������� �������
#
#    vm_reserve	    d26.2	�����, ����������������� ��� ������������� ������������ �����
#    vm_intercl	    d26.2	������������ �����, ��������� ��� ���������� � ����. �������
#
#    fee	          d26.2	��������� ����
#    fee_reserve	  d26.2	��������������� ������ ����� ��� ������
#
#    limit_spot_buy	      d26.2	����� �� ������� ������.
#    limit_spot_buy_used	d26.2	�������������� ����� �� ������� ������
#
#    coeff_go	        d16.5	����������� ����������� ��
#    coeff_liquidity	d16.5	����������� �����������
#
#    is_auto_update_limit	      i1	������� �������������� ��������� ������ �� ��������
#                                ������ ��� ������� ����� ��������: 0-���, 1-������.
#    is_auto_update_spot_limit	i1	������� �������������� ��������� ������� �� ������
#                               (�� �������, � �� �������) ��� ������� ����� ��������:
#                               0-���, 1-������.
#    no_fut_discount	i1	���������� ������������� ������ �� ���������: 1-������, 0-���.
#    limits_set	      i1	������� ��������� �������. 0 � ������ �����������
#    premium	        d26.2	������
#    premium_order_reserve	f	������ ������ ��� ������

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

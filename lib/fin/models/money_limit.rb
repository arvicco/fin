require 'fin/models/model'

module Fin
  # Represents information about client`s money, vm and various limits
  # Source table: FORTS_ PART_REPL::part � ���������� � ��������� � �������
  #
  class MoneyLimit < Model
    # Properties as per P2ClientGate API
    prop_accessor :client_code => :c7, #  ��� �������
                  :money_old => :'d26.2', #  ����� �� ������ ������
                  :money_amount => :'d26.2', #  ����� �����
                  :money_free => :'d26.2', #  �������� �����
                  :money_blocked => :'d26.2', #  ������������� �����
                  :pledge_old => :'d26.2', #  ������� �� ������ ������
                  :pledge_amount => :'d26.2', #  ����� �������
                  :pledge_free => :'d26.2', #  �������� �������
                  :pledge_blocked => :'d26.2', #  ������������� �������
                  :vm_reserve => :'d26.2', #  �����, ����������������� ��� ������������ �����
                  :vm_intercl => :'d26.2', #  M����, ��������� ��� ���������� � ����. �������
                  :fee => :'d26.2', #  ��������� ����
                  :fee_reserve => :'d26.2', #  ��������������� ������ ����� ��� ������
                  :limit_spot_buy => :'d26.2', #  ����� �� ������� ������.
                  :limit_spot_buy_used => :'d26.2', #  �������������� ����� �� ������� ������
                  :coeff_go => :'d16.5', #  ����������� ����������� ��
                  :coeff_liquidity => :'d16.5', #  ����������� �����������
                  :premium => :'d26.2', #  ������
                  :premium_order_reserve => :f, #  ������ ������ ��� ������

                  # Not extracted from record:
                  :is_auto_update_limit => :i1, #  ������� ������������� ������ �� ��������
                  #  ������ ��� ������� ����� ��������: 0-���, 1-������.
                  :is_auto_update_spot_limit => :i1, #  ������� ������������� ������� �� ������
                  # (�� �������, � �� �������) ��� ������� ����� ��������: 0-���, 1-������.
                  :no_fut_discount => :i1, #  ���������� ������������� ������ ��
                  # ���������: 1-������, 0-���.
                  :limits_set => :i1 #������� �������. 0 � ������ �����������

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

    def index
      repl_id
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

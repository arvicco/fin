require 'fin/models/model'

module Fin
  # Represents a single deal (trade) for one security
  # Source table: FORTS_FUTTRADE_REPL::deal � c�����
  #
  class Deal < Model

    # Properties as per P2ClientGate API
    prop_accessor [:isin_id, :isin] => :i4, #        ���������� �������� �����. �����������
                  :price => :'d16.5', #              ����
                  :amount => :i4, #                  �����, ���-�� ������ �����������
                  [:id_deal, :deal_id] => :i8, #     ����� ������
                  [:sess_id, :session_id] => :i4, #  ������������� ������
                  :moment => :t, #     ����� ���������� ������.
                  :pos => :i4, #       ���-�� ������� �� ����������� �� ����� ����� ������.
                  :nosystem => :i1, #  1-������������ ������, 0-�������
                  [:id_repo, :repo_id, :repo] => :i8, #  ����� ������ ����� ������ ����
                  :id_deal_multileg => :i8 # 		         ����� ������ �� ������

    # ��� ���� ����������� ������ ��� ����� ������:
    prop_accessor :code_sell => :c7, #     ��� ��������:status_sell,
                  :id_ord_sell => :i8, #   ����� ������ ��������
                  :ext_id_sell => :i4, #   ������� ����� �� ������ ��������
                  :comment_sell => :c20, # ����������� �� ������ ��������.
                  :trust_sell => :i1, #    ������� �������������� ���������� �� ������ ��������
                  :status_sell => :i4, #   ������ ������ �� ������� ��������
                  :hedge_sell => :i1, #    ������� �������� ������ �� ������� ��������
                  :fee_sell => :'d26.2', # ���� �� ������ ��������
                  :login_sell => :c20, #   ����� ������������ ��������
                  :code_rts_sell => :c7, # ��� ��� ��������
                  :code_buy => :c7, #      ��� ����������
                  :id_ord_buy => :i8, #    ����� ������ ����������.
                  :ext_id_buy => :i4, #    ������� ����� �� ������ ����������
                  :comment_buy => :c20, #  ����������� �� ������ ����������
                  :trust_buy => :i1, #     ������� �������������� ���������� �� ������ ����������
                  :status_buy => :i4, #    ������ ������ �� ������� ����������
                  :hedge_buy => :i1, #     ������� �������� ������ �� ������� ����������
                  :fee_buy => :'d26.2', #  ���� �� ������ ����������
                  :login_buy => :c20, #    ����� ������������ ����������
                  :code_rts_buy => :c7 # 	 ��� ��� ����������

    attr_accessor :book

    def self.index_for rec
      rec.GetValAsLong('id_deal')
    end

    def index
      deal_id
    end

    def price_as_integer
      price.round == price ? price.to_i : price
    end

    def inspect
      "#{moment}:#{repl_id}[#{isin}] #{price}>#{amount}"
    end

    alias to_s inspect
  end
end

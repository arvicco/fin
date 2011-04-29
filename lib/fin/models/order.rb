require 'fin/models/model'

module Fin

  # Source table: 	FORTS_FUTTRADE_REPL::orders_log - ������� ��������� ������ � ������.
  # Each record in this table represents an action related to some client Order:
  # - Order added, Order deleted, Order (partially) executed...
  #
  # In principle, you can construct/update NOT only Orders, but also Deals and Quotes
  # from information arriving via (full) 'orders_log' table...
  #
  class Order < Model
    model_class_id 14

    # Properties as per P2ClientGate API
    property [:id_ord, :order_id] => :i8, # 	 ����� ������
             [:sess_id, :session_id] => :i4, # ������������� ������
             :client_code => :c7, # 	  ��� �������
             :moment => :t, # 	        ����� ��������� ��������� ������
             :isin_id => :i4, # 	      ���������� �������� ������������� �����������
             :dir => :i1, # 	          �����������, 1 � �������, 2 � �������
             :price => :'d16.5', # 	    ���� (������)
             :amount => :i4, # 	        ���������� � ��������
             :amount_rest => :i4, # 	  ���������� ���������� � ������
             :comment => :c20, # 	      ����������� ��������
             :hedge => :i1, # 	        ������� �������� ������ (1 / 0)
             :trust => :i1, # 	        ������� ������ �������������� ���������� (1 / 0)
             :login_from => :c20, # 	  ����� ������������, ������������ ������
             :broker_to => :c7, # 	    ��� FORTS �����-�������� ������������ ������
             :broker_to_rts => :c7, # 	��� RTS �����-�������� ������������ ������
             :ext_id => :i4, # 	        ������� �����. ����������� � ������, ������
             :date_exp => :t, # 	      ���� ��������� ������
             :id_ord1 => :i4, # 	      ����� ������ ������ (��� ������������?)
             :broker_from_rts => :c7, # ��� ��� �����  - ��������� ������
             :id_deal => :i8, # 	      ������������� ������ �� ������ ������ ������� ������
             :deal_price => :'d16.5', # ���� ����������� ������
             :status => :i4, # 	        ������ ������ - ������������ ����� ������� �����:
             #    o	0x01 � ������������
             #    o	0x02 � ���������
             #    o	0x04 � ������������
             #    o	0x100000 � ������ �������� ����������� �������� ����������� ������
             #    o	0x200000 � ������ �������� ����������� �������� �������� ������
             #    o	0x400000 � ������ �������� ����������� ���������� ��������
             #    o	0x800000 � ������� �������� ������� ������ �� ������� �����-������
             :action => :i1 # 	        ��������� ��������, ������������ � �������:
#                 o	0 � ������ �������
#                 o	1 � ������ ���������
#                 o	2 � ������ ������� � ������

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

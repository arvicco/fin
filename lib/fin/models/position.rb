require 'fin/models/model'

module Fin
  # Represents a client`s position for one security
  # Source table: FORTS_POS_REPL::position
  #
  class Position < Model
    model_class_id 15

    # Properties as per P2ClientGate API
    property :isin_id => :i4, #        ���������� �������� ������������� �����������
             :client_code => :c7, #    ��� �������
             :open_qty => :i4, #       ���������� ������� �� ������ ������
             :buys_qty => :i4, #       ���������� ��������� ���������� � ���� ������
             :sells_qty => :i4, #      ���������� ��������� ���������� � ���� ������
             :pos => :i4, #            ������� �������
             :net_volume_rur => :'d26.2',
             #     H����-����� �����, � ������, �� ������� ���� ��������� ������.
             #     ������������� ����� � ������ ��������, ������������� � ������ �������������
             :last_deal_id => :i8 #    ������������� ��������� ������

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

require 'fin/models/model'

module Fin
  class Order < Model

    # Properties as per P2ClientGate API
    property :isin_id => :i8, #         ���������� �������� ������������� �����������
             :price => :'d16.5', #      ���� ���������
             :volume => :i8, # 	        ����� �������������� ���������
             [:dir, :buysell] => :i1, #	����������� ���������: ������� (1) /������� (2)
             :moment => :t #          	����� ���������� ���������� ���������

    attr_accessor :book

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

    def index
      repl_id
    end

    def price_as_integer
      if price && price.round == price
        price.to_i
      else
        price
      end
    end

    def to_s
      "#{repl_id}:#{price_as_integer}>#{volume}#{dir == 1 ? '+' : '-'}"
    end
  end
end

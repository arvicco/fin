require 'fin/models/model'

module Fin
  class Order < Model

    # Properties as per P2ClientGate API
    prop_accessor [:isin_id, :isin] => :i8,
                  :price => :'d16.5', #       ���� ���������
                  :volume => :i8, # 	        ����� �������������� ���������
                  [:dir, :buysell] => :i1, #	����������� ���������: ������� (1) /������� (2)
                  :moment => :t #          	  ����� ���������� ���������� ���������

    attr_accessor :book

    def self.index_for rec
      rec.GetValAsLong('replID')
    end

    def index
      repl_id
    end

    def price_as_integer
      price.round == price ? price.to_i : price
    end

    def inspect
      "#{repl_id}:#{price_as_integer}>#{volume}#{dir == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end
end

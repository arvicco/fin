require 'orders/models/model'

module Orders
  # Represents single price level for OrderBook for one security
  # (aggregate bid or ask with aggregate volume)
  #      // ������� "������ � �������"
  #      tOrderBookItem  = record
  #        id         : int64;
  #        rev        : int64;
  #        price         : double;  // ����
  #        volume        : double;  // ���-��
  #        buysell       : longint; // �������(1)/�������(2)
  #        order_book      : tOrderBook;
  class Order < Model
    # Properties as per P2ClientGate API
    prop_accessor :id, :rev,
                  [:isin_id, :isin],
                  :price, :volume,
                  [:dir, :buysell],
                  :moment

    attr_accessor :book

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{id}:#{price}>#{volume}#{dir == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end
end

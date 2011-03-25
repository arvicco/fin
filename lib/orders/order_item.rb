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
  class OrderItem
    attr_accessor :id, :rev, :isin_id, :price, :volume, :dir, :moment # Properties
    alias buysell dir
    alias buysell= dir=
    alias isin isin_id
    alias isin= isin_id=

    attr_accessor :book

    def initialize opts = {}
      opts.each { |key, value| send "#{key}=", value }
    end

    def price= val
      val = val.to_f
      @price = val.round == val ? val.to_i : val
    end

    def inspect
      "#{id}:#{price}>#{volume}#{buysell == 1 ? '+' : '-'}"
    end

    alias to_s inspect
  end
end

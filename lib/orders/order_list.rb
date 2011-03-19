require 'orders/order_book'

module Orders
  # Represents DOM (OrderBook) for one security
  # ������ ������� �� ����
  class OrderList < IndexedList
    attr_accessor :order_books

    def initialize
      @order_books = {}
      super
    end

    def index item
      item.id
    end

    def add item
      @order_books[item.isin_id] ||= Orders::OrderBook.new item.isin_id
      super
    end
  end
end

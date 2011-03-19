require 'order_book/order_book'

module OrderBook
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
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
      @order_books[item.isin_id] ||= OrderBook::OrderBook.new item.isin_id
      super
    end
  end
end

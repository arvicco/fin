require 'orders/order_book'

module Orders
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
      order_book = @order_books[item.isin_id] ||= Orders::OrderBook.new(item.isin_id)
      old_item = self[index item]
      remove old_item if old_item # Remove old item with the same index(id)
      order_book.add item         # Add item to appropriate order book
      super
    end

    def remove item
      # Removing item from appropriate order book when it's deleted from order list
      @order_books[item.isin_id].remove item if delete index item
      self
    end
  end
end

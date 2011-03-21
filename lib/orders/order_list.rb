require 'orders/order_book'

module Orders
  # Represents DOM (OrderBook) for one security
  # индекс стакана по цене
  class OrderList < IndexedList
    attr_accessor :order_books

    def initialize
      @order_books = Hash.new do |hash, key|
        hash[key] = Orders::OrderBook.new(key)
        hash[key]
      end
      super
    end

    def index item
      item.id
    end

    def add? item
      old_item = self[index item]
      remove old_item if old_item # Remove old item with the same index(id)
      if super
        @order_books[item.isin_id].add item # Add item to appropriate order book
        item
      end
    end

    def remove? item
      if super
        # Removing item from appropriate order book when it's deleted from order list
        @order_books[item.isin_id].remove item
        item
      end
    end
  end
end

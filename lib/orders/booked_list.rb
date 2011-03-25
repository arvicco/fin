require 'orders/order_book'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  class BookedList < IndexedList
    attr_accessor :books

    def initialize book_type
      @books = Hash.new do |hash, key|
        hash[key] = book_type.new(key)
        hash[key]
      end
      super()
    end

    def add? item
      old_item = self[index item]
      remove old_item if old_item # Remove old item with the same index(id)
      if super
        @books[item.isin].add item # Add item to appropriate order book
        item
      end
    end

    def remove? item
      if super
        # Removing item from appropriate order book when it's deleted from order list
        @books[item.isin].remove item
        item
      end
    end
  end
end

require 'orders/deal_book'

module Orders
  # Represents lists of ALL deals, indexed by id (replId)
  class DealList < IndexedList
    attr_accessor :deal_books

    def initialize
      @deal_books = Hash.new do |hash, key|
        hash[key] = Orders::DealBook.new(key)
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
        @deal_books[item.isin].add item # Add item to appropriate deal book
        item
      end
    end

    def remove? item
      if super
        # Remove item from appropriate deal book when it's deleted from deal list
        @deal_books[item.isin].remove item
        item
      end
    end
  end
end

require 'orders/indexed_list'

module Orders
  # Represents list of ALL items coming from DataStream (orders, deals and such).
  # In addition to main index by which items are listed here (replId, id, etc...),
  # there is additional index related to a single security(isin) - @books.
  # @books is a set of Books (such as OrderBook, DealBook), each related to a single isin.
  #
  class BookedList < ChangedList
    attr_accessor :books

    def initialize book_type
      @books = Hash.new do |hash, key|
        hash[key] = book_type.new(key)
        hash[key]
      end
      super()
    end

    # Overwrites/removes existing item with the same index
    def add? item
      if check item
        old_item = self[index item]
        remove old_item if old_item # Remove old item with the same index(id)
        if super
          @books[item.isin_id].add item # Add item to appropriate order book
          item
        end
      end
    end

    def remove? item
      if super
        # Removing item from appropriate order book when it's deleted from order list
        @books[item.isin_id].remove item
        item
      end
    end
  end
end

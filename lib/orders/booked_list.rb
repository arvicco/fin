require 'orders/indexed_list'

module Orders
  # Represents list of ALL items coming from DataStream (orders, deals and such).
  # In addition to main index by which items are listed here (replId, id, etc...),
  # there is additional index related to a single security(isin) - @books.
  # @books is a set of Books (such as OrderBook, DealBook), each related to a single isin.
  #
  class BookedList < IndexedList
    attr_accessor :books

    # Updated attribute should be set externally - only when data update
    # transaction is completed, and list data is known to be consistent
    # (e.g., when onStreamDataEnd event fires for DataStream)
    attr_accessor :updated

    def initialize book_type
      @updated = true
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

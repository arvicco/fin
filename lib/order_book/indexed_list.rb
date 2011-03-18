module OrderBook
  # Abstract (equivalent of SortedList)
  # базовый класс "сортированный список"
  class IndexedList < Hash

    # Returns default list index for items
    def index item
      item.object_id
    end

    # Noop by default (used to free/cleanup removed items in subclasses)
    def free item
    end

    # Adds new item to the list (replaces item with the same index)
    def add item
      self[index item] = item
      self
    end

    # Removes item from the list
    def remove item
      free item
      delete index item
      self
    end

    # Calls #free with each item being cleared
    def clear
      each_value { |item| free item }
      super
    end

    # Yields list items in order of their index
    def each
      if block_given?
        keys.sort.each { |key| yield self[key] }
      else
        ary = []
        keys.sort.each { |key| ary << self[key] }
        ary
      end
    end
  end
end

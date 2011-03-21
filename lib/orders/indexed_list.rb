module Orders
  # Abstract (equivalent of SortedList)
  # ������� ����� "������������� ������"
  class IndexedList < Hash

    def initialize
      @iteration_mutex = Mutex.new
      super
    end

    # Returns default list index for items
    def index item
      item.object_id
    end

    # Determines if item is worthy to be included in the list
    def check item
      true
    end

    # Adds new item to the list if it passes check
    # (replaces item with the same index)
    def add? item
      @iteration_mutex.synchronize { self[index item] = item } if check item
    end

    # Adds new item to the list, returning self for easy chaining
    def add item
      add? item
      self
    end

    alias << add

    # Removes item from the list, returns nil if nothing removed
    def remove? item
      @iteration_mutex.synchronize { delete index item }
    end

    # Removes item from the list
    def remove item
      remove? item
      self
    end

    # Removes item with given index from the list
    def delete_by_index index
      remove self[index] if self[index]
    end

    # Removes either all items, or items for which given block returns trueish value
    def clear
      if block_given?
        each { |item| remove item if yield item }
      else
        each { |item| remove item }
      end
    end

    # Yields list items (but NOT keys!) in order of their index
    def each
      keys_dup = []
      @iteration_mutex.synchronize { keys_dup = keys.dup }
      if block_given?
        keys_dup.sort.each { |key| yield self[key] }
      else
        keys_dup.sort.map { |key| self[key] }
      end
    end

    # Make direct setter private
    private :[]=
  end
end

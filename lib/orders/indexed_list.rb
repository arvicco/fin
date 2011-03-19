module Orders
  # Abstract (equivalent of SortedList)
  # базовый класс "сортированный список"
  class IndexedList < Hash

    # Returns default list index for items
    def index item
      item.object_id
    end

    # Adds new item to the list (replaces item with the same index)
    def add item
      self[index item] = item
      self
    end

    alias << add

    # Removes item from the list
    def remove item
      delete index item
      self
    end

    # Calls #remove for each item in list
    def clear
      each_value { |item| remove item }
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

    # Make direct setter private
    private :[]=
  end
end

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

    # Removes item with given index from the list
    def delete_by_index index
      remove self[index] if self[index]
    end

    # Removes either all items, or items for which given block returns trueish value
    def clear
      if block_given?
        each {|item| remove item if yield item}
      else
        each_value { |item| remove item }
      end
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

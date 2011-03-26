require 'orders/indexed_list'

module Orders
  # Represents IndexedList that tracks its own changes (dirty-tracking)
  class ChangedList < IndexedList

    attr_accessor :changed

    def initialize
      @changed = true
      super
    end

    def add? item
      if super
        @changed = true  # Mark List as changed
        item
      end
    end

    def remove? item
      if super
        @changed = true # Mark List as changed
        item
      end
    end
  end
end

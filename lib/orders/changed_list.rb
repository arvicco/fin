require 'orders/indexed_list'

module Orders
  # Represents IndexedList that tracks its own changes (dirty-tracking),
  # and counts its own updates
  class ChangedList < IndexedList

    attr_accessor :changed, :update_count

    def initialize
      @changed = true
      @update_count = 0
      super
    end

    def add? item
      if super
        @changed = true  # Mark List as changed
        @update_count += 1
        item
      end
    end

    def remove? item
      if super
        @changed = true # Mark List as changed
        @update_count += 1
        item
      end
    end
  end
end

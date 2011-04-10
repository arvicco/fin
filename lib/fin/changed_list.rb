require 'fin/indexed_list'

module Fin
  # Represents IndexedList that tracks its own changes (dirty-tracking),
  # and updates (series of changes resulting in a consistent state)
  class ChangedList < IndexedList

    # Changed attribute is set automatically, whenever item is actually added
    # or deleted from list (please note, change may leave data in inconsistent state!)
    attr_accessor :changed

    # Number of changes (successful item additions or removals)
    attr_accessor :change_count

    # Updated attribute should be set EXTERNALLY - only when data update
    # transaction is completed, and list data is known to be consistent
    # (e.g., when onStreamDataEnd event fires for DataStream)
    attr_accessor :updated

    def initialize
      @updated = true
      @changed = true
      @change_count = 0
      super
    end

    def add? item
      if super
        @changed = true  # Mark List as changed
        @change_count += 1
        item
      end
    end

    def remove? item
      if super
        @changed = true # Mark List as changed
        @change_count += 1
        item
      end
    end

    # Observers inform list that it's recent changes are reflected
    def update_noted
      @updated = false
      @changed = false
    end
  end
end

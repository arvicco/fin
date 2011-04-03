require 'orders/models/deal'
require 'orders/booked_list'

module Orders
  # Represents list of ALL Orders, indexed by id (replId)
  # Its @books is a set of OrderBooks by isin. Each OrderBook lists Orders by price.
  class DealList < BookedList

    def initialize
      super :item_type => Orders::Deal,
            :index => proc { |item| item.deal_id }
    end
  end
end


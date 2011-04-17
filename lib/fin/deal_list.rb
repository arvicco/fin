require 'fin/models/deal'
require 'fin/book_manager'

module Fin
  # Represents list of ALL Deals, indexed by deal_id
  # Its @books is a set of DealBooks by isin_id. Each DealBook lists Deals by deal_id.
  class DealList < ContainerList

    include BookManager

    def initialize
      super :item_type => Fin::Deal
      @book_index = proc { |item| item.deal_id }
    end

  end
end


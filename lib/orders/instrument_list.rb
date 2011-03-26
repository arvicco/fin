require 'orders/indexed_list'
require 'orders/models/instrument'

module Orders
  # Represents list of ALL instruments (securities), indexed by isin_id.
  #
  class InstrumentList < ChangedList

    def index item
      item.isin_id
    end

    def check item
      item.is_a?(Orders::Instrument) && item.isin_id
    end
  end
end

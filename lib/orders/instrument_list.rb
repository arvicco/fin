require 'orders/indexed_list'
require 'orders/models/instrument'

module Orders
  # Represents list of ALL instruments (securities), indexed by isin_id.
  # NB: It is derived directly from ChangedList, NOT BookedList (no Books!)
  class InstrumentList < ChangedList

    def index item
      item.isin_id
    end

    def check item
      item.is_a?(Orders::Instrument) && item.isin_id
    end

    def add_record rec
      add? Instrument.new :isin_id => rec.GetValAsLong('isin_id'),
                          :short_isin => rec.GetValAsString('short_isin'),
                          :name => rec.GetValAsString('name')
    end

    def remove_record rec, id
      remove? self[rec.GetValAsLong('isin_id')]
    end
  end
end

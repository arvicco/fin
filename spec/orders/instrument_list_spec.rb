require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::InstrumentList do
  subject { Orders::InstrumentList.new }
  let(:item_index) { @item.isin_id }
  let (:new_item_book_index) {new_item.isin_id}

  before(:each) do
    @item = Orders::Instrument.new :isin_id => 1234, :name => 'name'
    @item1 = Orders::Instrument.new :isin_id => 2345, :name => 'name1'
    @item2 = Orders::Instrument.new :isin_id => 5678, :name => 'name2'
  end

  it_behaves_like 'index_list'
end


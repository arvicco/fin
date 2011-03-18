require 'spec_helper'
require 'order_book/shared_examples.rb'

describe OrderBook::OrderBook do
  subject { OrderBook::OrderBook.new 123456}
  let(:item_index) { @item.id }

  before(:each) do
    @item = OrderBook::OrderBookItem.new
    @item1 = OrderBook::OrderBookItem.new
  end

  it_behaves_like 'index_list'

  its (:isin_id) {should == 123456}
  its (:changed) {should == true}
end


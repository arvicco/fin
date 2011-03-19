require 'spec_helper'
require 'order_book/shared_examples.rb'

describe OrderBook::IndexedList do
  subject { OrderBook::IndexedList.new }
  let(:item_index) { @item.object_id }

  before(:each) do
    @item = Object.new
    @item1 = Object.new
  end

  it_behaves_like 'index_list'
end


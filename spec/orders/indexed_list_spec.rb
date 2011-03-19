require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::IndexedList do
  subject { Orders::IndexedList.new }
  let(:item_index) { @item.object_id }

  before(:each) do
    @item = Object.new
    @item1 = Object.new
    @item2 = Object.new
  end

  it_behaves_like 'index_list'
end


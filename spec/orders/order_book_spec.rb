require 'spec_helper'
require 'order_book/shared_examples.rb'

describe OrderBook::OrderBook do
  subject { OrderBook::OrderBook.new 123456 }
  let(:item_index) { @item.price }

  before(:each) do
    @item = OrderBook::OrderBookItem.new :id => 0, :price => 20
    @item1 = OrderBook::OrderBookItem.new :id => 1, :price => 10
    @zero_price_item = OrderBook::OrderBookItem.new :id => 2, :price => 0
  end

  it_behaves_like 'index_list'

  its (:isin_id) {should == 123456}
  its (:changed) {should == true}

  describe 'adding item' do
    before(:each) do
      subject.add(@item).size.should == 1
      subject.changed = false
    end

    context 'with zero price' do
      it 'returns self' do
        subject.add(@zero_price_item).should == subject
      end

      it 'does not add such item to the list' do
        subject.add(@zero_price_item)
        subject[subject.index @zero_price_item].should == nil
        subject.size.should == 1
      end

      it 'does not set changed status to true' do
        subject.add(@zero_price_item)
        subject.changed.should == false
      end
    end

    it 'sets changed status to true if item was added' do
      subject.add(@item1)
      subject.changed.should == true
    end

  end

  describe 'removing item' do
    before(:each) do
      subject.add(@item).size.should == 1
      subject.changed = false
    end

    it 'sets changed status to true if item was removed' do
      subject.remove(@item)
      subject.changed.should == true
    end

    context 'that is not in list' do

      it 'returns self' do
        subject.remove(@item1).should == subject
      end

      it 'does not set changed status to true' do
        subject.remove(@item1)
        subject.changed.should == false
      end
    end
  end
end


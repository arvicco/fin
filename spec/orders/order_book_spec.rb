require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::OrderBook do
  subject { Orders::OrderBook.new 123456 }
  let(:item_index) { @item.price }

  before(:each) do
    @item = Orders::OrderBookItem.new :id => 0, :price => 20
    @item1 = Orders::OrderBookItem.new :id => 1, :price => 15
    @item2 = Orders::OrderBookItem.new :id => 2, :price => 10
    @zero_price_item = Orders::OrderBookItem.new :id => 3, :price => 0
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

      it 'does not set item`s order_book property' do
        subject.remove(@zero_price_item)
        @zero_price_item.order_book.should == nil
      end

    end

    it 'sets changed status to true if item was added' do
      subject.add(@item1)
      subject.changed.should == true
    end

    it 'sets added item`s order_book property' do
      subject.add(@item1)
      @item1.order_book.should == subject
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

    it 'unsets removed item`s order_book property' do
      subject.remove(@item)
      @item.order_book.should == nil
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


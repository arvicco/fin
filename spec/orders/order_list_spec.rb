require 'spec_helper'
require 'spec_helper'
require 'orders/shared_examples.rb'

shared_examples_for 'order_list_with_order_books' do
  it 'creates appropriate order book' do
    subject.add(new_item)
    subject.order_books.should have(expected_number_of_books).books
    order_book = subject.order_books[new_item.isin_id]
    order_book.should be_an Orders::OrderBook
    order_book.isin_id.should == new_item.isin_id
  end

  it 'adds this item to appropriate order book' do
    subject.add new_item
    order_book = subject.order_books[new_item.isin_id]
    order_book.should have_key new_item.price
    order_book[new_item.price].should == new_item
  end
end

describe Orders::OrderList do
  subject { Orders::OrderList.new }
  let(:item_index) { @item.id }

  before(:each) do
    @item = Orders::OrderBookItem.new :isin_id => 1234, :id => 0, :price => 20
    @item1 = Orders::OrderBookItem.new :isin_id => 1234, :id => 1, :price => 10
    @same_isin_item = @item1
    @diff_isin_item = Orders::OrderBookItem.new :isin_id => 5678, :id => 1, :price => 10
    @zero_price_item = Orders::OrderBookItem.new :isin_id => 1234, :id => 2, :price => 0
    @repeat_zero_price_item = Orders::OrderBookItem.new :isin_id => 1234, :id => 0, :price => 0
  end

  it_behaves_like 'index_list'

  specify { subject.order_books.should be_empty }

  describe 'adding item' do
    context 'to empty OrderList' do
      it 'creates appropriate order book' do
        subject.add(@item)
        subject.order_books.should_not be_empty
        subject.order_books.should have(1).book
        subject.order_books[@item.isin_id].should be_an Orders::OrderBook
        subject.order_books[@item.isin_id].isin_id.should == @item.isin_id
      end
    end

    context 'to non-empty OrderList' do
      before(:each) do
        subject.add(@item).size.should == 1
      end

      context 'with existing isin' do
        let(:new_item) { @same_isin_item }
        let(:expected_number_of_books) { 1 }

        it_behaves_like 'order_list_with_order_books'
      end

      context 'with different isin' do
        let(:new_item) { @diff_isin_item }
        let(:expected_number_of_books) { 2 }

        it_behaves_like 'order_list_with_order_books'
      end
    end

#    context 'with zero price' do
#      it 'returns self' do
#        subject.add(@zero_price_item).should == subject
#      end
#
#      it 'does not add such item to the list' do
#        subject.add(@zero_price_item)
#        subject[subject.index @zero_price_item].should == nil
#        subject.size.should == 1
#      end
#
#      it 'does not set changed status to true' do
#        subject.add(@zero_price_item)
#        subject.changed.should == false
#      end
#    end
#
    it 'sets changed status to true if item was added' do
      subject.add(@item1)
    end

  end

  describe 'removing item' do
#    before(:each) do
#      subject.add(@item).size.should == 1
##      @item.order_book?
#    end
#
#    it 'sets changed status to true if item was removed' do
#      subject.remove(@item)
#      subject.changed.should == true
#    end
#
#    context 'that is not in list' do
#
#      it 'returns self' do
#        subject.remove(@item1).should == subject
#      end
#
#      it 'does not set changed status to true' do
#        subject.remove(@item1)
#        subject.changed.should == false
#      end
#    end
  end
end


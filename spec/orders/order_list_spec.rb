require 'spec_helper'
require 'spec_helper'
require 'orders/shared_examples.rb'

#noinspection RubyResolve
describe Orders::OrderList do
  subject { Orders::OrderList.new }
  let(:item_index) { @item.id }

  before(:each) do
    @item = Orders::OrderBookItem.new :id => 0, :price => 20
    @item1 = Orders::OrderBookItem.new :id => 1, :price => 10
    @zero_price_item = Orders::OrderBookItem.new :id => 2, :price => 0
    @repeat_zero_price_item = Orders::OrderBookItem.new :id => 0, :price => 0
  end

  it_behaves_like 'index_list'

  specify { subject.order_books.should be_empty }

  describe 'adding item' do
    context 'to empty OrderList' do
      it 'creates appropriate order book' do
        subject.add(@item)
        subject.order_books.should_not be_empty
        subject.order_books[@item.isin_id].should be_an Orders::OrderBook
        subject.order_books.should have(1).book
      end

    end

    context 'to non-empty OrderList' do
      before(:each) do
        subject.add(@item).size.should == 1
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


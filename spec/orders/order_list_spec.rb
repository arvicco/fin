require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::OrderList do
  subject { Orders::OrderList.new }
  let(:item_index) { @item.id }
  let (:new_item_book_index) {new_item.price}
  let(:book_type) {Orders::OrderBook}

  before(:each) do
    @item = Orders::Order.new :isin_id => 1234, :id => 0, :price => 20
    @item1 = Orders::Order.new :isin_id => 1234, :id => 1, :price => 10
    @same_isin_item = @item1
    @item2 = Orders::Order.new :isin_id => 5678, :id => 2, :price => 10
    @diff_isin_item = @item2
    @zero_price_item = Orders::Order.new :isin_id => 1234, :id => 3, :price => 0
    @repeat_item = Orders::Order.new :isin_id => 1234, :id => 0, :price => 13
    @repeat_zero_price_item = Orders::Order.new :isin_id => 1234, :id => 0, :price => 0
  end

  it_behaves_like 'index_list'

  specify { subject.books.should be_empty }

  it 'returns order_book for any isin_id, even if it was not initialized' do
    order_book = subject.books[1313]
    order_book.should_not be_nil
    order_book.should be_an book_type
    order_book.should be_empty
  end

  describe 'adding item' do
    let(:expected_number_of_books) { 1 }

    context 'to empty OrderList' do
      let(:new_item) { @item }

      it_behaves_like 'adding_item_to_books'

      context 'with zero price' do
        let(:new_item) { @zero_price_item }

        it_behaves_like 'not_adding_item_to_books'
      end
    end

    context 'to non-empty OrderList' do
      before(:each) do
        subject.add(@item).size.should == 1
      end

      context 'with existing isin' do
        let(:new_item) { @same_isin_item }

        it_behaves_like 'adding_item_to_books'
      end

      context 'with different isin' do
        let(:new_item) { @diff_isin_item }
        let(:expected_number_of_books) { 2 }

        it_behaves_like 'adding_item_to_books'
      end

      context 'with zero price' do
        let(:new_item) { @zero_price_item }

        it_behaves_like 'not_adding_item_to_books'
      end

      context 'with repeat isin/id and non-zero price' do
        let(:new_item) { @repeat_item }

        it_behaves_like 'adding_item_to_books'

        it 'changes price of item in list' do
          subject.add new_item
          subject[item_index].price.should_not == @item.price
          subject[item_index].price.should == @repeat_item.price
        end

        it 'removes old item from appropriate order book' do
          subject.add new_item
          order_book = subject.books[@item.isin_id]
          order_book.should_not have_key @item.price
        end
      end

      context 'with repeat isin/id and zero price' do
        let(:new_item) { @repeat_zero_price_item }

        it_behaves_like 'not_adding_item_to_books'

        it 'removes old item from appropriate order book' do
          subject.add new_item
          order_book = subject.books[@item.isin_id]
          order_book.should_not have_key @item.price
          order_book.size.should == 0
        end
      end
    end
  end

  describe 'removing item' do
    before(:each) do
      subject.add(@item).size.should == 1
    end

    context 'with existing item' do
      let(:unwanted_item) { @item }
      let(:expected_size) { 0 }

      it 'deletes item from the list' do
        subject.remove(unwanted_item)
        subject[unwanted_item.id].should == nil
        subject.size.should == expected_size
      end

      it 'removes item from its related order book' do
        subject.remove(unwanted_item)
        subject.books[unwanted_item.isin_id].should_not have_key unwanted_item.price
      end
    end

    context 'with non-existing item' do
      let(:unwanted_item) { @item1 }
      let(:expected_size) { 1 }

      it 'still returns the list itself' do
        subject.remove(unwanted_item).should == subject
      end

      it 'deletes nothing from the list' do
        subject.remove(unwanted_item)
        subject[item_index].should == @item
        subject.size.should == expected_size
      end
    end
  end
end


require 'spec_helper'
require 'spec_helper'
require 'orders/shared_examples.rb'

shared_examples_for 'adding_item_to_order_books' do
  it_behaves_like 'creating_order_books'

  it 'adds this item to appropriate order book' do
    subject.add new_item
    order_book = subject.order_books[new_item.isin_id]
    order_book.should have_key new_item.price
    order_book[new_item.price].should == new_item
  end
end

shared_examples_for 'not_adding_item_to_order_books' do
  it_behaves_like 'creating_order_books'

  it 'does not add this item to order list' do
    subject.add new_item
    order_book = subject.order_books[new_item.isin_id]
    order_book.should_not have_key new_item.price
    order_book[new_item.price].should == nil
  end
end

shared_examples_for 'creating_order_books' do
  it 'creates appropriate order book' do
    subject.add(new_item)
    subject.order_books.should have(expected_number_of_books).books
    order_book = subject.order_books[new_item.isin_id]
    order_book.should be_an Orders::OrderBook
    order_book.isin_id.should == new_item.isin_id
  end

  it 'sets item`s order_book property correctly' do
    subject.add(new_item)
    if new_item.price == 0
      new_item.order_book.should == nil
    else
      order_book = subject.order_books[new_item.isin_id]
      new_item.order_book.should == order_book
    end
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
    @repeat_item = Orders::OrderBookItem.new :isin_id => 1234, :id => 0, :price => 13
    @repeat_zero_price_item = Orders::OrderBookItem.new :isin_id => 1234, :id => 0, :price => 0
  end

  it_behaves_like 'index_list'

  specify { subject.order_books.should be_empty }

  describe 'adding item' do
    let(:expected_number_of_books) { 1 }

    context 'to empty OrderList' do
      let(:new_item) { @item }

      it_behaves_like 'adding_item_to_order_books'

      context 'with zero price' do
        let(:new_item) { @zero_price_item }

        it_behaves_like 'not_adding_item_to_order_books'
      end
    end

    context 'to non-empty OrderList' do
      before(:each) do
        subject.add(@item).size.should == 1
      end

      context 'with existing isin' do
        let(:new_item) { @same_isin_item }

        it_behaves_like 'adding_item_to_order_books'
      end

      context 'with different isin' do
        let(:new_item) { @diff_isin_item }
        let(:expected_number_of_books) { 2 }

        it_behaves_like 'adding_item_to_order_books'
      end

      context 'with zero price' do
        let(:new_item) { @zero_price_item }

        it_behaves_like 'not_adding_item_to_order_books'
      end

      context 'with repeat isin/id and non-zero price' do
        let(:new_item) { @repeat_item }

        it_behaves_like 'adding_item_to_order_books'

        it 'changes price of item in list' do
          subject.add new_item
          subject[item_index].price.should_not == @item.price
          subject[item_index].price.should == @repeat_item.price
        end

        it 'removes old item from appropriate order book' do
          subject.add new_item
          order_book = subject.order_books[@item.isin_id]
          order_book.should_not have_key @item.price
        end
      end

      context 'with repeat isin/id and zero price' do
        let(:new_item) { @repeat_zero_price_item }

        it_behaves_like 'not_adding_item_to_order_books'

        it 'removes old item from appropriate order book' do
          subject.add new_item
          order_book = subject.order_books[@item.isin_id]
          order_book.should_not have_key @item.price
        end
      end
    end

    it 'sets changed status to true if item was added' do
      subject.add(@item1)
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
        subject.order_books[unwanted_item.isin_id].should_not have_key unwanted_item.price
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
        subject[@item.id].should == @item
        subject.size.should == expected_size
      end
    end
  end
end


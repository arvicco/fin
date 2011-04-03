require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::Book, 'as a replacement for OrderBook' do
  subject { Orders::Book.new :item_type => Orders::Order,
            :book_index => proc { |item| item.price },
            :book_condition => proc { |item| item.price > 0},
            :isin_id => 123456 }

  let(:item_index) { @item.price }

  before(:each) do
    @item = Orders::Order.new :id => 0, :price => 20, :isin => 123456
    @item1 = Orders::Order.new :id => 1, :price => 15, :isin => 123456
    @item2 = Orders::Order.new :id => 2, :price => 10, :isin => 123456
    @zero_price_item = Orders::Order.new :id => 3, :price => 0, :isin => 123456
    @wrong_isin_item = Orders::Order.new :id => 4, :price => 50, :isin => 456123
  end

  it_behaves_like 'changed_list'

  its (:isin_id) {should == 123456}
  its (:isin) {should == 123456}
  its (:changed) {should == true}

  it 'is possible to set its #changed attribute' do
    subject.changed = false
    subject.changed.should == false
  end

  it 'but #isin(_id) attribute is not settable' do
    expect { subject.isin_id = 1313 }.to raise_error NoMethodError
    expect { subject.isin = 1313 }.to raise_error NoMethodError
  end

  describe '#check' do
    it 'fails if item is not an Order' do
      subject.check(1).should == false
    end

    it 'fails if item has wrong isin_id' do
      subject.check(@wrong_isin_item).should == false
    end

    it 'fails if item.price <= 0' do
      subject.check(@zero_price_item).should == false
    end

    it 'returns true otherwise' do
      subject.check(@item).should == true
    end
  end

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

      it 'does not set item`s book property' do
        subject.remove(@zero_price_item)
        @zero_price_item.book.should == nil
      end

    end

    it 'sets changed status to true if item was added' do
      subject.add(@item1)
      subject.changed.should == true
    end

    it 'sets added item`s book property' do
      subject.add(@item1)
      @item1.book.should == subject
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

    it 'unsets removed item`s book property' do
      subject.remove(@item)
      @item.book.should == nil
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

describe Orders::Book, 'as a replacement for DealBook' do
  subject { Orders::Book.new :item_type => Orders::Deal,
            :book_index => proc { |item| item.deal_id },
            :isin_id => 123456 }
  let(:item_index) { @item.deal_id }

  before(:each) do
    @item = Orders::Deal.new :id => 0, :deal_id => 20, :isin => 123456
    @item1 = Orders::Deal.new :id => 1, :deal_id => 30, :isin => 123456
    @item2 = Orders::Deal.new :id => 2, :deal_id => 40, :isin => 123456
    @wrong_isin_item = Orders::Deal.new :id => 3, :deal_id => 50, :isin => 456123
  end

  it_behaves_like 'changed_list'

  its (:isin_id) {should == 123456}
  its (:isin) {should == 123456}
  its (:changed) {should == true}

  it 'is possible to set its #changed attribute' do
    subject.changed = false
    subject.changed.should == false
  end

  it 'but #isin(_id) attribute is not settable' do
    expect { subject.isin_id = 1313 }.to raise_error NoMethodError
    expect { subject.isin = 1313 }.to raise_error NoMethodError
  end

  describe '#check' do
    it 'fails if item is not a Deal' do
      subject.check(1).should == false
    end

    it 'fails if item has wrong isin_id' do
      subject.check(@wrong_isin_item).should == false
    end

    it 'returns true otherwise' do
      subject.check(@item).should == true
    end
  end

  describe 'adding item' do
    before(:each) do
      subject.add(@item).size.should == 1
      subject.changed = false
    end

    it 'sets changed status to true if item was added' do
      subject.add(@item1)
      subject.changed.should == true
    end

    it 'sets added item`s book property' do
      subject.add(@item1)
      @item1.book.should == subject
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

    it 'unsets removed item`s book property' do
      subject.remove(@item)
      @item.book.should == nil
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




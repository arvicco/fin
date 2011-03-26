require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::DealBook do
  subject { Orders::DealBook.new 123456 }
  let(:item_index) { @item.deal_id }

  before(:each) do
    @item = Orders::Deal.new :id => 0, :deal_id => 20, :isin => 123456
    @item1 = Orders::Deal.new :id => 1, :deal_id => 30, :isin => 123456
    @item2 = Orders::Deal.new :id => 2, :deal_id => 40, :isin => 123456
    @wrong_isin_item = Orders::Deal.new :id => 3, :deal_id => 50, :isin => 456123
  end

  it_behaves_like 'index_list'

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


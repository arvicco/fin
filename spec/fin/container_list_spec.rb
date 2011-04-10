require 'spec_helper'
require 'fin/shared_examples.rb'

describe Fin::ContainerList do
  subject { Fin::ContainerList.new :item_type => Fin::Model }
  let(:item_index) { @item.index }

  before(:each) do
    @item = Fin::Model.new
    @item1 = Fin::Model.new
    @item2 = Fin::Model.new
  end

  its(:item_type) { should == Fin::Model }
  it_behaves_like 'changed_list'

  describe "#check" do
    it 'checks items for their type' do
      [@item, @item1, @item2].each do |item|
        subject.check(item).should be_true
      end
      [nil, "none", 1313, [1, 2, 3], Object.new].each do |non_item|
        subject.check(non_item).should == false
      end
    end
  end

  describe "#index" do
    it 'returns items`s own index' do
      [@item, @item1, @item2].each do |item|
        subject.index(item).should == item.index
      end
    end

    it 'returns nil for incorrect items' do
      [nil, "none", 1313, [1, 2, 3], Object.new].each do |non_item|
        subject.index(non_item).should == nil
      end
    end
  end

  describe "#add_record" do # for compatibility
    it 'delegates to @item_type to create new item' do
      subject.item_type.should_receive(:from_record).with("Blah").and_return(@item)
      subject.add_record "Blah"
    end
  end
end

describe Fin::ContainerList, 'as a replacement for InstrumentList' do
  subject { Fin::ContainerList.new :item_type => Fin::Instrument }
  let(:item_index) { @item.isin_id }
  let (:new_item_book_index) {new_item.isin_id}

  before(:each) do
    @item = Fin::Instrument.new :isin_id => 1234, :name => 'name'
    @item1 = Fin::Instrument.new :isin_id => 2345, :name => 'name1'
    @item2 = Fin::Instrument.new :isin_id => 5678, :name => 'name2'
  end

  it_behaves_like 'changed_list'
end


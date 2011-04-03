require 'spec_helper'
require 'orders/shared_examples.rb'

describe Orders::ContainerList do
  subject { Orders::ContainerList.new :item_type => Orders::Model }
  let(:item_index) { @item.index }

  before(:each) do
    @item = Orders::Model.new
    @item1 = Orders::Model.new
    @item2 = Orders::Model.new
  end

  its(:item_type) { should == Orders::Model }
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


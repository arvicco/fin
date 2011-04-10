require 'spec_helper'
require 'fin/shared_examples.rb'

describe Fin::IndexedList do
  subject { Fin::IndexedList.new }
  let(:item_index) { @item.object_id }

  before(:each) do
    @item = Object.new
    @item1 = Object.new
    @item2 = Object.new
  end

  it_behaves_like 'index_list'

  it 'checks all items as worthy, by default' do
    subject.check(@item).should == true
  end
end


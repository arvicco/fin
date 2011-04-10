require 'spec_helper'
require 'fin/shared_examples.rb'

describe Fin::ChangedList do
  subject { Fin::ChangedList.new }
  let(:item_index) { @item.object_id }

  before(:each) do
    @item = Object.new
    @item1 = Object.new
    @item2 = Object.new
  end

  it_behaves_like 'changed_list'
end


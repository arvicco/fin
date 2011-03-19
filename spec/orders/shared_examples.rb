shared_examples_for 'index_list' do

  describe 'items get/set' do
    it 'returns item from list by their index' do
      subject.add(@item)[item_index].should == @item
    end

    it 'returns nil when item with requested index not in collection' do
      subject[item_index].should == nil
    end

    it 'is not possible to add item into collection directly' do
      expect { subject[item_index] = @item }.to raise_error NoMethodError
    end
  end

  describe '#index' do
    it 'indexes arbitrary items by their index (redefined in subclasses)' do
      subject.index(@item).should == item_index
    end
  end

  describe '#add' do
    it 'returns self for easy method chaining' do
      subject.add(@item).should == subject
    end

    it 'adds items to indexed list' do
      subject.add(@item)
      subject.values.should include @item
      subject[item_index].should == @item
      subject.size.should == 1
    end

    it 'adds items to using alias <<' do
      subject << @item
      subject.values.should include @item
      subject[item_index].should == @item
      subject.size.should == 1
    end
  end

  describe '#remove' do
    before(:each) { subject.add(@item).add(@item1).size.should == 2 }

    context 'removing existing item' do
      it 'returns self for easy method chaining' do
        subject.remove(@item).should == subject
      end

      it 'removes item from indexed list' do
        subject.remove(@item)
        subject.values.should_not include @item
        subject[item_index].should == nil
      end

      it 'does not remove other items' do
        subject.remove(@item)
        subject.values.should include @item1
        subject.size.should == 1
      end
    end

    context 'deleting non-existing items by index' do
      it 'still returns self' do
        subject.remove(@item2).should == subject
      end

      it 'removes nothing from the list' do
        subject.remove(@item2)
        subject.values.should include @item, @item1
        subject.size.should == 2
      end
    end
  end

  describe '#delete_by_index' do
    before(:each) { subject.add(@item).add(@item1) }
    context 'deleting existing item by index' do

      it 'returns self' do
        subject.delete_by_index(item_index).should == subject
      end

      it 'deletes item with given index from the list' do
        subject.delete_by_index(item_index)
        subject.values.should_not include @item
        subject[item_index].should == nil
      end

      it 'calls #remove on this item to properly remove it' do
        subject.should_receive(:remove).with(@item)
        subject.delete_by_index(item_index)
      end

      it 'does not remove other items' do
        subject.delete_by_index(item_index)
        subject.values.should include @item1
        subject.size.should == 1
      end
    end

    context 'deleting non-existing items by index' do
      it 'returns nil' do
        subject.delete_by_index(subject.index @item2).should == nil
      end

      it 'removes nothing from the list' do
        subject.delete_by_index(subject.index @item2)
        subject.values.should include @item, @item1
        subject.size.should == 2
      end
    end
  end

  describe '#clear' do
    before(:each) { subject.add(@item).add(@item1) }

    context 'without block' do
      it 'removes all items from list' do
        subject.clear
        subject.should be_empty
      end

      it 'ensures that #remove method is called once for each item in list' do
        subject.should_receive(:remove).twice
        subject.clear
      end
    end

    context 'with block given' do
      it 'yields items from list in index order' do
        @count = 0
        @items = []
        subject.clear do |item|
          @count += 1
          @items << item
        end
        @count.should == 2
        if subject.index(@item) < subject.index(@item1)
          @items.should == [@item, @item1]
        else
          @items.should == [@item1, @item]
        end
      end

      it 'only removes items for which given block returns true' do
        subject.should_receive(:remove).once
        subject.clear { |item| true if item == @item1 }
        subject.should have_key item_index
      end
    end
  end

  describe '#each' do
    before(:each) { subject.add(@item).add(@item1) }

    it 'yields items from list in index order' do
      @count = 0
      @items = []
      subject.each do |item|
        @count += 1
        @items << item
      end
      @count.should == 2
      if subject.index(@item) < subject.index(@item1)
        @items.should == [@item, @item1]
      else
        @items.should == [@item1, @item]
      end
    end

    it 'returns list item in array, sorted by their index, if no block given' do
      if subject.index(@item) < subject.index(@item1)
        subject.each.should == [@item, @item1]
      else
        subject.each.should == [@item1, @item]
      end
    end
  end
end


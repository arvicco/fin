shared_examples_for 'index_list' do
  describe '#index' do
    it 'indexes arbitrary items by object_id (default)' do
      subject.index(@item).should == item_index
    end
  end

  describe '#free' do
    it 'is defined' do
      expect { subject.free(@item) }.to_not raise_error
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
    end
  end

  describe '#add' do
    before(:each) { subject.add(@item).add(@item1) }

    it 'returns self for easy method chaining' do
      subject.remove(@item).should == subject
    end

    it 'removes item from indexed list' do
      subject.remove(@item)
      subject.values.should_not include @item
      subject[item_index].should == nil
    end

    it 'ensures that #free method is called with item before remove' do
      subject.should_receive(:free).with(@item).once
      subject.remove(@item)
    end
  end

  describe '#clear' do
    before(:each) { subject.add(@item).add(@item1) }

    it 'removes all items from list' do
      subject.clear
      subject.should be_empty
    end

    it 'ensures that #free method is called once for each item in list' do
      subject.should_receive(:free).twice
      subject.clear
    end
  end

  describe '#each' do
    before(:each) { subject.add(@item).add(@item1) }

    it 'yields items from list in index order' do
      @count = 0
      subject.each do |item|
        @count += 1
        case @count
          when 1
            if subject.index(@item) < subject.index(@item1)
              item.should == @item
            else
              item.should == @item1
            end
          when 2
            if subject.index(@item) < subject.index(@item1)
              item.should == @item1
            else
              item.should == @item
            end
        end
      end
      @count.should == 2
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


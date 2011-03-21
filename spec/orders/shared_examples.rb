shared_examples_for 'removing items' do
  context 'removing existing item' do
    it 'returns to indicate success' do
      remove_operation(@item).should == returns_if_remove_success #@item
    end

    it 'removes item from indexed list' do
      remove_operation(@item)
      subject.values.should_not include @item
      subject.should_not have_key item_index
      subject[item_index].should == nil
    end

    it 'does not remove other items' do
      remove_operation(@item)
      subject.values.should include @item1
      subject.size.should == 1
    end

    it 'is synchronized to allow other threads iterations' do
      expect_sync 3
      remove_operation @item
      remove_operation @item1
      remove_operation @item2
    end
  end

  context 'deleting non-included items' do
    it 'returns to indicate failure' do
      remove_operation(@item2).should == returns_if_remove_failed #nil
    end

    it 'removes nothing from the list' do
      remove_operation(@item2)
      subject.values.should include @item, @item1
      subject.size.should == 2
    end
  end
end

shared_examples_for 'adding items' do
  it 'runs check on item' do
    subject.should_receive(:check).with(@item)
    add_operation(@item)
  end

  it 'adds item only if it passes check' do
    subject.should_receive(:check).with(@item).and_return(false)
    add_operation(@item).should == returns_if_add_failed
    subject.values.should_not include @item
    subject.should_not have_key item_index
    subject.size.should == 0
  end

  it 'returns either self or item in case of success' do
    add_operation(@item).should == returns_if_add_success
  end

  it 'adds items to indexed list' do
    add_operation(@item)
    subject.values.should include @item
    subject.should have_key item_index
    subject[item_index].should == @item
    subject.size.should == 1
  end

  it 'does not add same items twice' do
    subject.add(@item)
    add_operation(@item)
    subject.values.should include @item
    subject.should have_key item_index
    subject[item_index].should == @item
    subject.size.should == 1
  end

  it 'even adds item using << as alias to #add' do
    subject << @item
    subject.values.should include @item
    subject.should have_key item_index
    subject[item_index].should == @item
    subject.size.should == 1
  end

  it 'is synchronized to allow other threads iterations' do
    expect_sync 3
    add_operation @item
    add_operation @item1
    subject << @item2
  end
end

shared_examples_for 'index_list' do

  def expect_sync times = 1
    mutex = subject.instance_variable_get(:@iteration_mutex)
    mutex.should be_a Mutex
    mutex.should_receive(:synchronize).exactly(times).times
  end

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

  describe '#add?' do
    def add_operation item
      subject.add? item
    end

    let(:returns_if_add_success) { @item }
    let(:returns_if_add_failed) { nil }
    it_behaves_like 'adding items'
  end

  describe '#add' do
    def add_operation item
      subject.add item
    end

    let(:returns_if_add_success) { subject }
    let(:returns_if_add_failed) { subject }
    it_behaves_like 'adding items'
  end

  context 'with couple of items in the list' do
    before(:each) { subject.add(@item).add(@item1).size.should == 2 }

    describe '#remove?' do
      def remove_operation item
        subject.remove? item
      end

      let(:returns_if_remove_success) { @item }
      let(:returns_if_remove_failed) { nil }
      it_behaves_like 'removing items'
    end

    describe '#remove' do
      def remove_operation item
        subject.remove item
      end

      let(:returns_if_remove_success) { subject }
      let(:returns_if_remove_failed) { subject }
      it_behaves_like 'removing items'
    end

    describe '#clear' do
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

      it 'is synchronized to allow other threads add items while we`re iterating' do
        expect_sync 2
        subject.each { |item|}
        subject.each
      end
    end
  end
end


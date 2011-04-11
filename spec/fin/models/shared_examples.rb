shared_examples_for 'model' do
  it 'has index method' do
    expect { subject.index }.to_not raise_error
  end

  it 'has pre-defined replID, replRev, replAct properties' do
    expect do
      subject.replID
      subject.repl_id
      subject.replRev
      subject.repl_rev
      subject.rev
      subject.replAct
      subject.repl_act
    end.to_not raise_error
  end

  context 'enumerating model properties' do

    specify { should be_kind_of Enumerable }

    describe '#each' do
      it 'enumerates through property names and respective values' do
        @property_names = []
        @property_values = []
        subject.each do |name, value|
          @property_names << name
          @property_values << value
        end
        @property_values.size.should == subject.class.attribute_types.size
        @property_names.should == subject.class.attribute_types.keys
      end
    end

    describe '#each_property' do
      it 'enumerates through property names and respective values' do
        @property_names = []
        @property_values = []
        subject.each_property do |name, value|
          @property_names << name
          @property_values << value
        end
        @property_values.size.should == subject.class.attribute_types.size
        @property_names.should == subject.class.attribute_types.keys
      end
    end
  end

  describe '#inspect' do
    it 'lists all properties' do
      subject.inspect.should == subject.map { |prop, value| "#{prop}=#{value}" }.join(',')
    end
  end
end

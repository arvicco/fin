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

  context 'properties' do

    it 'has all properties set correctly' do
      property_hash.each { |prop, value| subject.send(prop).should == value }
    end

    context 'enumeration' do

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
  end

  describe '#inspect' do
    it 'lists all properties' do
#      p subject.inspect
#      p subject.each.to_a
      subject.inspect.should == subject.map { |prop, value| "#{prop}=#{value}" }.join(',')
    end
  end

  describe '.model_class_id' do
    it 'is properly set' do
      described_class.model_class_id.should == model_class_id
    end

    it 'is added to model classes list' do
      id = described_class.model_class_id
      Fin::Model.model_classes[id].should == described_class
      described_class.model_classes[id].should == described_class
    end
  end
end

shared_examples_for 'price_as_integer' do
  describe '#price_as_integer' do
    it 'returns price as Integer if it is Integer' do
      subject.price = 1313.0
      subject.price.should == 1313.0
      subject.price_as_integer.should == 1313
      subject.price = 1313.5
      subject.price.should == 1313.5
      subject.price_as_integer.should == 1313.5
    end
  end
end

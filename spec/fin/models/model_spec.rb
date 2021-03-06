require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Model do
  let(:model_class_id) { 0 }
  let(:property_hash) { {} }

  it_behaves_like 'model'
end

describe Fin::Model, "as a base class for BD models" do
  let(:model_class) { Class.new(Fin::Model) }
  let(:model_item) { model_class.new }

  describe 'Class inheriting from Model' do
    it 'has pre-defined replID, replRev, replAct properties' do
      expect do
        model_item.replID
        model_item.repl_id
        model_item.replRev
        model_item.repl_rev
        model_item.rev
        model_item.replAct
        model_item.repl_act
      end.to_not raise_error
    end
  end

  describe '.property' do
    it 'creates attr_accessor in a model class, given a String or Symbol' do
      model_class.instance_eval do
        property :foo => :i4, 'bar' => :i4
      end
      model_item.should respond_to :foo
      model_item.should respond_to :foo=
      model_item.should respond_to :bar
      model_item.should respond_to :bar=
    end

    it 'creates attr_accessor with aliases in a model class, given an Array' do
      model_class.instance_eval do
        property [:foo, 'bar', :baz] => :i4
      end
      model_item.should respond_to :foo=
      model_item.should respond_to :bar=
      model_item.should respond_to :baz=
      model_item.should respond_to :foo
      model_item.should respond_to :bar
      model_item.should respond_to :baz
      model_item.foo = 1313
      model_item.foo.should == 1313
      model_item.bar.should == 1313
      model_item.baz.should == 1313
    end

    it 'accepts a mix of Symbols and Arrays' do
      model_class.instance_eval do
        property :foo => :i4, ['bar', :baz] => :i4
      end
      model_item.should respond_to :foo=
      model_item.should respond_to :bar=
      model_item.should respond_to :baz=
      model_item.should respond_to :foo
      model_item.should respond_to :bar
      model_item.should respond_to :baz
      model_item.foo = 1313
      model_item.foo.should == 1313
      model_item.bar.should_not == 1313
      model_item.baz.should_not == 1313
      model_item.bar = 42
      model_item.foo.should == 1313
      model_item.bar.should == 42
      model_item.baz.should == 42
    end
  end # describe '.property'

  describe ' model subclasses tracking' do
    describe '.model_class_id' do
      it 'sets/accesses uniform class identifier for this class' do
        model_class.model_class_id.should be_nil
        model_class.instance_eval do
          model_class_id 1313
        end
        model_class.model_class_id.should == 1313
        model_class.model_class_id.should == 1313
      end

      it 'adds class identifier to list of model classes' do
        model_class.instance_eval do
          model_class_id 1313
        end
        Fin::Model.model_classes[1313].should == model_class
      end

      it 'is 0 for Fin::Model itself' do
        Fin::Model.model_class_id.should == 0
      end
    end

    describe '.model_classes' do
      it 'contains at least a reference to Fin::Model itself' do
        Fin::Model.model_classes.should have_value Fin::Model
      end

    end

  end

  context 'with mock record' do
    let(:rec) do # Mocks raw OLE record received through P2ClientGate callback
      mock('record').tap do |mock|
        mock.stub(:GetValAsString) do |field|
          case field
            when 'name'
              'rec_name'
            when 'time'
              'rec_time'
            when 'price'
              '16.7'
            when 'net'
              '89.89'
          end
        end
        mock.stub(:GetValAsLong) do |field|
          case field
            when 'foo'
              14
            when 'bar'
              15
          end
        end
        mock.stub(:GetValAsVariant) do |field|
          case field
            when 'longint'
              1322222222455664
            when 'time'
              20100101003030000
            when 'replID'
              11
            when 'replRev'
              12
            when 'replAct'
              13
          end
        end
      end
    end

    describe '.from_record' do
      it 'creates new model object' do
        object = model_class.from_record(rec)
        object.should be_a_kind_of model_class
      end

      it ' extracts attributes from raw (OLE) record' do
        object = model_class.from_record(rec)
        object.replID.should == 11
        object.repl_id.should == 11
        object.replRev.should == 12
        object.repl_rev.should == 12
        object.replAct.should == 13
        object.repl_act.should == 13
      end

      it 'is created by property macro based on defined properties' do
        model_class.instance_eval do
          property :foo => :i4, ['bar', :baz] => :i1
        end
        rec.should_receive(:GetValAsLong).with('foo').and_return(14)
        rec.should_receive(:GetValAsLong).with('bar').and_return(15)
        object = model_class.from_record(rec)
        object.foo.should == 14
        object.bar.should == 15
        object.baz.should == 15
      end

      it 'calling property macro twice still generates a valid extractor' do
        model_class.instance_eval do
          property :foo => :i4
          property ['bar', :baz] => :i1
        end
        object = model_class.from_record(rec)
        object.repl_id.should == 11
        object.repl_rev.should == 12
        object.repl_act.should == 13
        object.foo.should == 14
        object.bar.should == 15
        object.baz.should == 15
      end

      it 'extracts properties of all types correctly' do
        model_class.instance_eval do
          property :foo => :i4, :bar => :i1, :longint => :i8,
                   :name => :c4, :time => :t,
                   :price => :'d3.1', :net => :f
        end
        object = model_class.from_record(rec)
        object.repl_id.should == 11
        object.repl_rev.should == 12
        object.repl_act.should == 13
        object.foo.should == 14
        object.bar.should == 15
        object.longint.should == 1322222222455664
        object.name.should == 'rec_name'
        object.time.should == 20100101003030000
        object.price.should be_within(0.0001).of(16.7)
        object.net.should be_within(0.0001).of(89.89)
      end
    end # from_record

    context 'serialization' do
      before do
        model_class.instance_eval do
          model_class_id 1313
          property :foo => :i4, :bar => :i1, :longint => :i8,
                   :name => :c4, :time => :t,
                   :price => :'d3.1', :net => :f
        end
      end

      describe '.from_msg' do
        it 'allows restoration of original object from serializable data' do
          msg = model_class.to_msg(rec)
          object = model_class.from_msg(msg)
          object.repl_id.should == 11
          object.repl_rev.should == 12
          object.repl_act.should == 13
          object.foo.should == 14
          object.bar.should == 15
          object.longint.should == 1322222222455664
          object.name.should == 'rec_name'
          object.time.should == 20100101003030000
          object.price.should be_within(0.0001).of(16.7)
          object.net.should be_within(0.0001).of(89.89)
        end
      end # from_msg

      describe '.to_msg', 'Class method!' do
        it 'converts RECORD into serializable representation' do
          model_class.to_msg(rec).should ==
              [1313, 11, 12, 13, 14, 15, 1322222222455664, "rec_name", 20100101003030000 , 16.7, 89.89]
        end
      end # to_msg


      describe '#to_msg', 'Instance method!' do
        it 'converts OBJECT into serializable representation' do
          object = model_class.from_record(rec)
          object.to_msg.should ==
              [1313, 11, 12, 13, 14, 15, 1322222222455664, "rec_name", 20100101003030000 , 16.7, 89.89]
        end
      end # to_msg

    end #serialization
  end # with mock record
end

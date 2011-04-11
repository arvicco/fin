require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Model do
  it_behaves_like 'model'
end

describe Fin::Model, "as a base class for BD models" do
  let(:model_class) { Class.new(Fin::Model) }
  let(:model_item) { model_class.new }

  describe 'Class inheriting from Model' do
    it 'defines replID, replRev, replAct properties' do
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

  describe 'class macros' do

    describe '.prop_accessor' do
      it 'creates attr_accessor in a model class, given a String or Symbol' do
        model_class.instance_eval do
          prop_accessor :foo => :i4, 'bar' => :i4
        end
        model_item.should respond_to :foo
        model_item.should respond_to :foo=
        model_item.should respond_to :bar
        model_item.should respond_to :bar=
      end

      it 'creates attr_accessor with aliases in a model class, given an Array' do
        model_class.instance_eval do
          prop_accessor [:foo, 'bar', :baz] => :i4
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
          prop_accessor :foo => :i4, ['bar', :baz] => :i4
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
    end # describe '.prop_accessor'
  end
end

require 'spec_helper'
require 'orders/models/shared_examples'

describe Orders::Model do
  it_behaves_like 'model'
end

describe Orders::Model, "as a base class for BD models" do
  let(:model_class) { Class.new(Orders::Model) }
  let(:model_item) {model_class.new}
  describe 'class macros' do

    describe '.prop_reader' do
      it 'creates attr_reader in a model class, given a String or Symbol' do
        model_class.instance_eval do
          prop_reader :foo, 'bar'
        end
        model_item.should respond_to :foo
        model_item.should_not respond_to :foo=
        model_item.should respond_to :bar
        model_item.should_not respond_to :bar=
      end

      it 'creates attr_reader with aliases in a model class, given an Array' do
        model_class.instance_eval do
          prop_reader [:foo, 'bar', :baz]
        end
        model_item.should_not respond_to :foo=
        model_item.should_not respond_to :bar=
        model_item.should_not respond_to :baz=
        model_item.should respond_to :foo
        model_item.should respond_to :bar
        model_item.should respond_to :baz
        model_item.instance_variable_set(:@foo, 1313)
        model_item.foo.should == 1313
        model_item.bar.should == 1313
        model_item.baz.should == 1313
      end

      it 'accepts a mix of Symbols and Arrays' do
        model_class.instance_eval do
          prop_reader :foo, ['bar', :baz]
        end
        model_item.should_not respond_to :foo=
        model_item.should_not respond_to :bar=
        model_item.should_not respond_to :baz=
        model_item.should respond_to :foo
        model_item.should respond_to :bar
        model_item.should respond_to :baz
        model_item.instance_variable_set(:@foo, 1313)
        model_item.foo.should == 1313
        model_item.bar.should_not == 1313
        model_item.baz.should_not == 1313
        model_item.instance_variable_set(:@bar, 42)
        model_item.foo.should == 1313
        model_item.bar.should == 42
        model_item.baz.should == 42
      end
    end # describe '.prop_reader'

    describe '.prop_accessor' do
      it 'creates attr_accessor in a model class, given a String or Symbol' do
        model_class.instance_eval do
          prop_accessor :foo, 'bar'
        end
        model_item.should respond_to :foo
        model_item.should respond_to :foo=
        model_item.should respond_to :bar
        model_item.should respond_to :bar=
      end

      it 'creates attr_accessor with aliases in a model class, given an Array' do
        model_class.instance_eval do
          prop_accessor [:foo, 'bar', :baz]
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
          prop_accessor :foo, ['bar', :baz]
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

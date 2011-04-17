require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Order do

  it_behaves_like 'model'

  describe '#new with empty initializer' do
    subject { Fin::Order.new }

    it 'has all nil properties' do
      subject.class.attribute_types.each {|prop, _| subject.send(prop).should == nil}
    end
  end

  describe '#new with opts' do
    let(:property_hash) do
      {:repl_id => 12,
      }
    end
    subject { Fin::Order.new property_hash }

    it 'has all properties set correctly' do
      property_hash.each {|prop, value| subject.send(prop).should == value}
    end

    describe '#to_s' do
      it 'is just right' do
        subject.to_s.should == "12:1234>12345+"
      end
    end

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

    describe '#index' do
      it 'should be equal to repl_id' do
        subject.index.should == subject.repl_id
      end
    end
  end
end


require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Order do
  let(:model_class_id) { 14 }

  shared_examples_for 'order_with_set_properties' do

    it_behaves_like 'model'
    it_behaves_like 'price_as_integer'

    describe '#to_s' do
      it 'is just right' do
        subject.to_s.should == "12:1234>12345+"
      end
    end

    describe '#index' do
      it 'should be equal to repl_id' do
        subject.index.should == subject.repl_id
      end
    end
  end

  describe '#new with empty initializer' do
    let(:property_hash) { {} }
    subject { Fin::Order.new }

    it_behaves_like 'model'

    it 'has all nil properties' do
      subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
    end
  end

  describe '#new with opts' do
    let(:property_hash) do
      {:repl_id => 12,
       :amount => 12345,
       :price => 1234,
       :dir => 1,
       :local_stamp => 20100101003030000
      }
    end
    subject { Fin::Order.new property_hash }
    it_behaves_like 'order_with_set_properties'
  end
end


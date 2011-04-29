require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Quote do
  let(:model_class_id) { 16 }

  shared_examples_for 'quote_with_set_properties' do
    it_behaves_like 'model'
    it_behaves_like 'price_as_integer'

    its (:book) {should == 123456}

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
    subject { Fin::Quote.new }

    its (:book) {should == nil}

    it_behaves_like 'model'

    it 'has all nil properties' do
      subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
    end
  end

  describe 'with properties' do
    let(:property_hash) do
      {:isin_id => 1234567,
       :repl_id => 12,
       :rev => 123,
       :repl_act => 1,
       :price => 1234.0,
       :volume => 12345,
       :buysell => 1,
       :moment => 'time',
       :book => 123456
      }
    end

    context 'initialized with property options hash' do
      subject { Fin::Quote.new property_hash }
      it_behaves_like 'quote_with_set_properties'
    end

    context 'initialized with property array' do
      subject { Fin::Quote.new 12,
                               123,
                               1,
                               1234567,
                               1234.0,
                               12345,
                               1,
                               'time',
                               :book => 123456
      }

      it_behaves_like 'quote_with_set_properties'
    end
  end
end

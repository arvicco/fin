require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Quote do

  describe '#new with empty initializer' do
    let(:property_hash) { {} }
    subject { Fin::Quote.new }

    its (:book) {should == nil}

    it_behaves_like 'model'

    it 'has all nil properties' do
      subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
    end
  end

  describe '#new with opts' do
    let(:property_hash) do
      {:isin_id => 1234567,
       :repl_id => 12,
       :rev => 123,
       :price => 1234.0,
       :volume => 12345,
       :buysell => 1,
       :moment => 'time',
       :book => 123456
      }
    end
    subject { Fin::Quote.new property_hash }

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
end


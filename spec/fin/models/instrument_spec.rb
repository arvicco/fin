require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Instrument do
  let(:model_class_id) { 12 }

  shared_examples_for 'instrument_with_set_properties' do

    its (:session_id) {should == 1213}
    it_behaves_like 'model'

    describe '#to_s' do
      it 'is just right' do
        subject.to_s.should == "name:short isin[symbolic isin]"
      end
    end

    describe '#index' do
      it 'should be equal to isin_id' do
        subject.index.should == subject.isin_id
      end
    end
  end

  describe '#new with empty initializer' do
    let(:property_hash) { {} }
    subject { Fin::Instrument.new }

    it_behaves_like 'model'

    it 'has all nil properties' do
      subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
    end
  end

  describe '#new with opts' do
    let(:property_hash) do
      {:repl_id => 12,
       :rev => 123,
       :isin_id => 1234567,
       :isin => 'symbolic isin',
       :short_isin => 'short isin',
       :name => 'name',
       :sess_id => 1213,
      }
    end
    subject { Fin::Instrument.new property_hash }
    it_behaves_like 'instrument_with_set_properties'

  end
end


require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Position do

  describe '#new with empty initializer' do
    let(:property_hash) { {} }
    subject { Fin::Position.new }

    it_behaves_like 'model'

    it 'has all nil properties' do
      subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
    end
  end

  describe '#new with opts' do
    let(:property_hash) do
      {:isin_id => 1234567,
       :repl_id => 12,
       :repl_rev => 123,
       :client_code => 'fz1234',
       :open_qty => 12345,
       :buys_qty => 1212,
       :sells_qty => 1213,
       :pos => 12344,
       :net_volume_rur => 123456,
       :last_deal_id => 654321,

      }
    end
    subject { Fin::Position.new property_hash }

    it_behaves_like 'model'

    describe '#to_s' do
      it 'is just right' do
        subject.to_s.should == "12[1234567] 12344, open: 12345, buys: 1212, sells: 1213"
      end
    end

    describe '#index' do
      it 'should be equal to isin_id' do
        subject.index.should == subject.isin_id
      end
    end
  end
end


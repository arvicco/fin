require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Deal do
  let(:model_class_id) { 11 }

  shared_examples_for 'deal_with_set_properties' do

    its (:id_deal) {should == 1212}
    its (:session_id) {should == 1213}
    its (:book) {should == 123456}

    it_behaves_like 'model'
    it_behaves_like 'price_as_integer'

    describe '#to_s, #inspect' do
      it '#to_s reveals meaningful info' do
        subject.to_s.should == "time:1212[1234567] 1234>12345"
      end

      it '#inspect lists ALL properties' do
        subject.inspect.should == "replID=12,replRev=123,replAct=,isin_id=1234567,price=1234,amount=12345,id_deal=1212,sess_id=1213,moment=time,pos=121212,id_ord_sell=123456,id_ord_buy=654321,nosystem=0,id_deal_multileg=0,id_repo=0,code_sell=,ext_id_sell=,comment_sell=,trust_sell=,status_sell=0,hedge_sell=,fee_sell=,login_sell=,code_rts_sell=,code_buy=,ext_id_buy=,comment_buy=,trust_buy=,status_buy=0,hedge_buy=,fee_buy=,login_buy=,code_rts_buy="
      end

      describe '#index' do
        it 'should be equal to deal_id' do
          subject.index.should == subject.deal_id
        end
      end
    end

    describe '#new with empty initializer' do
      let(:property_hash) { {} }
      subject { Fin::Deal.new }

      it_behaves_like 'model'

      it 'has all nil properties' do
        subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
      end

      its (:book) {should == nil}
    end

    describe '#new with opts' do

      let(:property_hash) do
        {:isin_id => 1234567,
         :repl_id => 12,
         :rev => 123,
         :price => 1234,
         :amount => 12345,
         :deal_id => 1212,
         :sess_id => 1213,
         :moment => 'time',
         :status_sell => 0,
         :status_buy => 0,
         :id_ord_sell => 123456,
         :id_ord_buy => 654321,
         :pos => 121212, # Кол-во позиций по инструменту на рынке после сделки.
         :nosystem => 0, # 1-внесистемная сделка, 0-обычная
         :id_repo => 0, # Номер другой части сделки РЕПО
         :id_deal_multileg => 0, # Номер сделки по связке
         :book=> 123456,
        }
      end
      subject { Fin::Deal.new property_hash }
      it_behaves_like 'deal_with_set_properties'
    end
  end
end


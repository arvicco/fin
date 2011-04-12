require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::Deal do

  it_behaves_like 'model'

  describe '#new with empty initializer' do
    subject { Fin::Deal.new }

    its (:repl_id) {should == nil} # replId
    its (:rev) {should == nil} # replRev
    its (:isin_id) {should == nil}
    its (:deal_id) {should == nil}
    its (:id_deal) {should == nil}
    its (:sess_id) {should == nil}
    its (:session_id) {should == nil}
    its (:price) {should == nil}
    its (:amount) {should == nil}
    its (:moment) {should == nil}
    its (:status_sell) {should == nil}
    its (:status_buy) {should == nil}
    its (:id_ord_sell) {should == nil}
    its (:id_ord_buy) {should == nil}
    its (:pos) {should == nil} # Кол-во позиций по инструменту на рынке после сделки.
    its (:nosystem) {should == nil} # 1-внесистемная сделка, 0-обычная
    its (:id_repo) {should == nil} # Номер другой части сделки РЕПО
    its (:id_deal_multileg) {should == nil} # Номер сделки по связке

    its (:book) {should == nil}

  end


  describe '#new with opts' do
    subject { Fin::Deal.new :isin_id => 1234567,
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

    its (:isin_id) {should == 1234567}
    its (:repl_id) {should == 12}
    its (:rev) {should == 123}
    its (:price) {should == 1234}
    its (:amount) {should == 12345}

    its (:deal_id) {should == 1212}
    its (:id_deal) {should == 1212}
    its (:sess_id) {should == 1213}
    its (:session_id) {should == 1213}
    its (:moment) {should == 'time'}
    its (:status_sell) {should == 0}
    its (:status_buy) {should == 0}
    its (:id_ord_sell) {should == 123456}
    its (:id_ord_buy) {should == 654321}
    its (:pos) {should == 121212} # Кол-во позиций по инструменту на рынке после сделки.
    its (:nosystem) {should == 0} # 1-внесистемная сделка, 0-обычная
    its (:id_repo) {should == 0} # Номер другой части сделки РЕПО
    its (:id_deal_multileg) {should == 0} # Номер сделки по связке

    its (:book) {should == 123456}

    describe '#to_s, #inspect' do
      it '#to_s reveals meaningful info' do
        subject.to_s.should == "time:12[1234567] 1234>12345"
      end

      it '#inspect lists ALL properties' do
        subject.inspect.should == "replID=12,replRev=123,replAct=,isin_id=1234567,price=1234,amount=12345,id_deal=1212,sess_id=1213,moment=time,pos=121212,nosystem=0,id_deal_multileg=0,id_repo=0,code_sell=,id_ord_sell=123456,ext_id_sell=,comment_sell=,trust_sell=,status_sell=0,hedge_sell=,fee_sell=,login_sell=,code_rts_sell=,code_buy=,id_ord_buy=654321,ext_id_buy=,comment_buy=,trust_buy=,status_buy=0,hedge_buy=,fee_buy=,login_buy=,code_rts_buy="
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
      it 'should be equal to deal_id' do
        subject.index.should == subject.deal_id
      end
    end
  end
end


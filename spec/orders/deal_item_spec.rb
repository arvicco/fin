require 'spec_helper'

describe Orders::DealItem do
  describe '#new with empty initializer' do
    subject { Orders::DealItem.new }

    its (:id) {should == nil} # replId
    its (:rev) {should == nil} # replRev
    its (:isin_id) {should == nil}
    its (:isin) {should == nil}
    its (:deal_id) {should == nil}
    its (:deal) {should == nil}
    its (:sess_id) {should == nil}
    its (:sess) {should == nil}
    its (:price) {should == nil}
    its (:volume) {should == nil}
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

#  replID=6607871
#  replRev=6607876
#  replAct=0
#  id_deal=6608653
#  sess_id=3753
#  isin_id=154995
#  price=22194.00000
#  amount=3
#  moment=2011/03/23 15:30:04.746
#  id_ord_sell=2292952813
#  id_ord_buy=2292952838
#  status_sell=0
#  status_buy=0
#  pos=71148
#  nosystem=0
#  id_repo=0
#  id_deal_multileg=0

    # Поля code_sell, comment_sell, ext_id_sell, trust_sell, hedge_sell,
    # login_sell, code_rts_sell, fee_sell, code_buy, comment_buy, ext_id_buy,
    # trust_buy, hedge_buy, login_buy, code_rts_buy, fee_buy  -
    # - заполняются только для своих сделок.

#  code_sell=
#  code_buy=
#  ext_id_sell=0
#  comment_sell=
#  trust_sell=0
#  ext_id_buy=0
#  comment_buy=
#  trust_buy=0
#  hedge_sell=0
#  hedge_buy=0
#  fee_sell=0.00
#  fee_buy=0.00
#  login_sell=
#  login_buy=
#  code_rts_sell=
#  code_rts_buy=
  end


  describe '#new with opts' do
    subject { Orders::DealItem.new :isin => 1234567,
                                   :id => 12,
                                   :rev => 123,
                                   :price => 1234,
                                   :volume => 12345,
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
    its (:isin) {should == 1234567}
    its (:id) {should == 12}
    its (:rev) {should == 123}
    its (:price) {should == 1234}
    its (:volume) {should == 12345}
    its (:amount) {should == 12345}

    its (:deal_id) {should == 1212}
    its (:deal) {should == 1212}
    its (:sess_id) {should == 1213}
    its (:sess) {should == 1213}
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
      it 'is just right' do
        subject.to_s.should == "time:12[1234567] 1234>12345"
        subject.inspect.should == "time:12[1234567] 1234>12345"
      end
    end

    describe '#price=' do
      it 'converts given price to Integer if it is integer' do
        subject.price = 1313.0
        subject.price.should == 1313
        subject.price.should be_an Integer
      end
    end
  end
end


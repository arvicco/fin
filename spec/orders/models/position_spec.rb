require 'spec_helper'
require 'orders/models/shared_examples'

describe Orders::Position do

  it_behaves_like 'model'

  describe '#new with empty initializer' do
    subject { Orders::Position.new }

    its (:repl_id) {should == nil} # replId
    its (:repl_rev) {should == nil} # replRev
    its (:isin_id) {should == nil}
    its (:client_code) {should == nil}
    its (:open_qty) {should == nil}
    its (:buys_qty) {should == nil}
    its (:sells_qty) {should == nil}
    its (:pos) {should == nil}
    its (:net_volume_rur) {should == nil}
    its (:last_deal_id) {should == nil}

#    isin_id	i4	Уникальный числовой идентификатор инструмента
#    client_code	c7	Код клиента
#    open_qty	i4	Количество позиций на начало сессии
#    buys_qty	i4	Количество купленных контрактов в ходе сессии
#    sells_qty	i4	Количество проданных контрактов в ходе сессии
#    pos	i4	Текущая позиция
#    net_volume_rur	d26.2	Нетто-сумма денег, в рублях, на которую были совершены сделки. Положительное число – деньги приходят, отрицательное – деньги выплачиваются
#    last_deal_id	i8	Идентификатор последней сделки
  end


  describe '#new with opts' do
    subject { Orders::Position.new :isin_id => 1234567,
                                   :repl_id => 12,
                                   :repl_rev => 123,
                                   :client_code => 1234,
                                   :open_qty => 12345,
                                   :buys_qty => 1212,
                                   :sells_qty => 1213,
                                   :pos => 12344,
                                   :net_volume_rur => 123456,
                                   :last_deal_id => 654321,

    }

    its (:isin_id) {should == 1234567}
    its (:isin) {should == 1234567}
    its (:id) {should == 12}
    its (:rev) {should == 123}
    its (:client_code) {should == 1234}
    its (:open_qty) {should == 12345}

    its (:buys_qty) {should == 1212}
    its (:sells_qty) {should == 1213}
    its (:pos) {should == 12344}
    its (:net_volume_rur) {should == 123456}
    its (:last_deal_id) {should == 654321}

    describe '#to_s, #inspect' do
      it 'is just right' do
        subject.to_s.should == "12[1234567] 12344, open: 12345, buys: 1212, sells: 1213"
        subject.inspect.should == "12[1234567] 12344, open: 12345, buys: 1212, sells: 1213"
      end
    end

    describe '#index' do
      it 'should be equal to isin_id' do
        subject.index.should == subject.isin_id
      end
    end
  end
end


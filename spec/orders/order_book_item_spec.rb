require 'spec_helper'

describe Orders::OrderBookItem do
  describe '#new with empty initializer' do
    subject { Orders::OrderBookItem.new }

    its (:isin_id) {should == nil}
    its (:isin) {should == nil}
    its (:id) {should == nil}
    its (:rev) {should == nil}
    its (:price) {should == nil}
    its (:volume) {should == nil}
    its (:buysell) {should == nil}
    its (:order_book) {should == nil}
  end

  describe '#new with opts' do
    subject { Orders::OrderBookItem.new :isin => 1234567,
                                           :id => 12,
                                           :rev => 123,
                                           :price => 1234,
                                           :volume => 12345,
                                           :buysell => 1,
                                           :order_book => 123456
    }

    its (:isin_id) {should == 1234567}
    its (:isin) {should == 1234567}
    its (:id) {should == 12}
    its (:rev) {should == 123}
    its (:price) {should == 1234}
    its (:volume) {should == 12345}
    its (:buysell) {should == 1}
    its (:order_book) {should == 123456}

   describe '#to_s, #inspect' do
     it 'is just right' do
       subject.to_s.should == "12:1234>12345+"
       subject.inspect.should == "12:1234>12345+"
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


require 'spec_helper'
require 'orders/models/shared_examples'

describe Orders::Order do

  it_behaves_like 'model'

  describe '#new with empty initializer' do
    subject { Orders::Order.new }

    its (:repl_id) {should == nil}
    its (:rev) {should == nil}
    its (:isin_id) {should == nil}
    its (:isin) {should == nil}
    its (:price) {should == nil}
    its (:volume) {should == nil}
    its (:dir) {should == nil}
    its (:buysell) {should == nil}
    its (:moment) {should == nil}
    its (:book) {should == nil}
  end

  describe '#new with opts' do
    subject { Orders::Order.new :isin => 1234567,
                                :repl_id => 12,
                                :rev => 123,
                                :price => 1234,
                                :volume => 12345,
                                :buysell => 1,
                                :moment => 'time',
                                :book => 123456
    }

    its (:repl_id) {should == 12}
    its (:rev) {should == 123}
    its (:isin_id) {should == 1234567}
    its (:isin) {should == 1234567}
    its (:price) {should == 1234}
    its (:volume) {should == 12345}
    its (:dir) {should == 1}
    its (:buysell) {should == 1}
    its (:moment) {should == 'time'}
    its (:book) {should == 123456}

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

    describe '#index' do
      it 'should be equal to replId' do
        subject.index.should == subject.repl_id
      end
    end
  end
end


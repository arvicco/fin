require 'spec_helper'
require 'orders/models/shared_examples'

describe Orders::Instrument do

  it_behaves_like 'model'

  describe '#new with empty initializer' do
    subject { Orders::Instrument.new }

    its (:id) {should == nil} # replId
    its (:rev) {should == nil} # replRev
    its (:isin_id) {should == nil}
    its (:isin) {should == nil}
    its (:short_isin) {should == nil}
    its (:sess_id) {should == nil}
    its (:session) {should == nil}
  end


  describe '#new with opts' do
    subject { Orders::Instrument.new :id => 12,
                                     :rev => 123,
                                     :isin_id => 1234567,
                                     :isin => 'symbolic isin',
                                     :short_isin => 'short isin',
                                     :name => 'name',
                                     :sess_id => 1213,
    }

    its (:isin_id) {should == 1234567}
    its (:isin) {should == 'symbolic isin'}
    its (:short_isin) {should == 'short isin'}
    its (:name) {should == 'name'}
    its (:id) {should == 12}
    its (:rev) {should == 123}
    its (:sess_id) {should == 1213}
    its (:sess) {should == 1213}

    describe '#to_s, #inspect' do
      it 'is just right' do
        subject.to_s.should == "name:short isin[symbolic isin]"
        subject.inspect.should == "name:short isin[symbolic isin]"
      end
    end

    describe '#index' do
      it 'should be equal to isin_id' do
        subject.index.should == subject.isin_id
      end
    end
  end
end


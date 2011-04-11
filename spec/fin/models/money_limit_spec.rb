require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::MoneyLimit do

  it_behaves_like 'model'

  describe '#new with empty initializer' do
    subject { Fin::MoneyLimit.new }

    its (:repl_id) {should == nil} # replId
    its (:repl_rev) {should == nil} # replRev
    its (:client_code) {should == nil}
    its (:money_old) {should == nil}
    its (:money_amount) {should == nil}
    its (:money_free) {should == nil}
    its (:money_blocked) {should == nil}
    its (:pledge_old) {should == nil}
    its (:pledge_amount) {should == nil}
    its (:pledge_free) {should == nil}
    its (:pledge_blocked) {should == nil}
    its (:vm_reserve) {should == nil}
    its (:vm_intercl) {should == nil}
    its (:fee) {should == nil}
    its (:fee_reserve) {should == nil}
    its (:limit_spot_buy) {should == nil}
    its (:limit_spot_buy_used) {should == nil}
    its (:coeff_go) {should == nil}
    its (:coeff_liquidity) {should == nil}
    its (:is_auto_update_limit) {should == nil}
    its (:is_auto_update_spot_limit) {should == nil}
    its (:no_fut_discount) {should == nil}
    its (:limits_set) {should == nil}
    its (:premium) {should == nil}
    its (:premium_order_reserve) {should == nil}

  end

  describe '#new with opts' do
    subject { Fin::MoneyLimit.new :repl_id => 12,
                                     :repl_rev => 123,
                                     :client_code => '1234',
                                     :money_old => 1234,
                                     :money_amount => 12345,
                                     :money_free => 123456,
                                     :money_blocked => 1,
                                     :pledge_old => 12,
                                     :pledge_amount => 123,
                                     :pledge_free => 1234,
                                     :pledge_blocked => 12345,
                                     :vm_reserve => 123456,
                                     :vm_intercl => 1,
                                     :fee => 12,
                                     :fee_reserve => 123,
                                     :limit_spot_buy => 1234,
                                     :limit_spot_buy_used => 12345,
                                     :coeff_go => 123456,
                                     :coeff_liquidity => 1,
                                     :is_auto_update_limit => 1,
                                     :is_auto_update_spot_limit => 0,
                                     :no_fut_discount => 1,
                                     :limits_set => 1,
                                     :premium => 123,
                                     :premium_order_reserve => 1234,
    }

    its (:repl_id) {should == 12} # replId
    its (:repl_rev) {should == 123} # replRev
    its (:client_code) {should == '1234'}
    its (:money_old) {should == 1234}
    its (:money_amount) {should == 12345}
    its (:money_free) {should == 123456}
    its (:money_blocked) {should == 1}
    its (:pledge_old) {should == 12}
    its (:pledge_amount) {should == 123}
    its (:pledge_free) {should == 1234}
    its (:pledge_blocked) {should == 12345}
    its (:vm_reserve) {should == 123456}
    its (:vm_intercl) {should == 1}
    its (:fee) {should == 12}
    its (:fee_reserve) {should == 123}
    its (:limit_spot_buy) {should == 1234}
    its (:limit_spot_buy_used) {should == 12345}
    its (:coeff_go) {should == 123456}
    its (:coeff_liquidity) {should == 1}
    its (:is_auto_update_limit) {should == 1}
    its (:is_auto_update_spot_limit) {should == 0}
    its (:no_fut_discount) {should == 1}
    its (:limits_set) {should == 1}
    its (:premium) {should == 123}
    its (:premium_order_reserve) {should == 1234}

    describe '#to_s' do
      it 'is just right' do
        right = "Money: Old 1234 Amt 12345 Free 123456 Blck 1 " +
            "Pledge: Old 12 Amt 123 Free 1234 Blck 12345 " +
            "VM: Reserve 123456 Intercl 1 Fee: 12 Reserve 123 " +
            "Limit Spot: Buy 1234 Used 12345"
        subject.to_s.should == right
      end
    end

    describe '#index' do
      it 'should be equal to repl_id' do
        subject.index.should == subject.repl_id
      end
    end
  end
end


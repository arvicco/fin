require 'spec_helper'
require 'fin/models/shared_examples'

describe Fin::MoneyLimit do
  let(:model_class_id) { 13 }

  shared_examples_for 'limit_with_set_properties' do

    it_behaves_like 'model'

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

  describe '#new with empty initializer' do
    let(:property_hash) { {} }
    subject { Fin::MoneyLimit.new }

    it_behaves_like 'model'

    it 'has all nil properties' do
      subject.class.attribute_types.each { |prop, _| subject.send(prop).should == nil }
    end
  end

  describe '#new with opts' do
    let(:property_hash) do
      {:repl_id => 12,
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
    end
    subject { Fin::MoneyLimit.new property_hash }
    it_behaves_like 'limit_with_set_properties'
  end
end


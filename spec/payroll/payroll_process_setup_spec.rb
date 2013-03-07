require 'spec_helper'

describe 'Payroll Process Setup' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    pay_tags = PayTagGateway.new
    pay_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(pay_tags, pay_concepts, period)
  end

  describe 'inserting term and get code_order' do
    it 'returns code_order == 1 at beginning' do
      period = PayrollPeriod::NOW
      tag_code_name = PayTagGateway::REF_SALARY_BASE
      @payroll_process.ins_term(period, tag_code_name, 3, amount_monthly:  3000)
      @payroll_process.ins_term(period, tag_code_name, 5, amount_monthly:  5000)
      @payroll_process.ins_term(period, tag_code_name, 4, amount_monthly:  4000)
      @payroll_process.ins_term(period, tag_code_name, 2, amount_monthly:  2000)
      pay_tag = @payroll_process.add_term(tag_code_name,  amount_monthly: 15000)
      pay_tag.code_order.should == 1
    end

    it 'returns code_order == 3 in the middle' do
      period = PayrollPeriod::NOW
      tag_code_name = PayTagGateway::REF_SALARY_BASE
      @payroll_process.ins_term(period, tag_code_name, 5, amount_monthly:  5000)
      @payroll_process.ins_term(period, tag_code_name, 1, amount_monthly:  1000)
      @payroll_process.ins_term(period, tag_code_name, 4, amount_monthly:  4000)
      @payroll_process.ins_term(period, tag_code_name, 2, amount_monthly:  2000)
      pay_tag = @payroll_process.add_term(tag_code_name,  amount_monthly: 16000)
      pay_tag.code_order.should == 3
    end

    it 'returns code_order == 6 at the end' do
      period = PayrollPeriod::NOW
      tag_code_name = PayTagGateway::REF_SALARY_BASE
      @payroll_process.ins_term(period, tag_code_name, 3, amount_monthly:  3000)
      @payroll_process.ins_term(period, tag_code_name, 5, amount_monthly:  5000)
      @payroll_process.ins_term(period, tag_code_name, 1, amount_monthly:  1000)
      @payroll_process.ins_term(period, tag_code_name, 4, amount_monthly:  4000)
      @payroll_process.ins_term(period, tag_code_name, 2, amount_monthly:  2000)
      pay_tag = @payroll_process.add_term(tag_code_name,  amount_monthly: 16000)
      pay_tag.code_order.should == 6
    end
  end

  describe 'payroll period' do
    it 'returns payroll period january 2013' do
      @payroll_process.period.code.should == 201301
    end
  end

end

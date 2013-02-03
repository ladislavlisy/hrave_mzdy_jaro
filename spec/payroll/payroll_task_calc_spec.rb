require 'spec_helper'

describe "Payroll Tasks Calculation" do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    pay_tags = PayTagGateway.new
    pay_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(period, pay_tags, pay_concepts)
  end

  describe "insert term of salary" do
    it "returns code_order == 1" do
      period = PayrollPeriod::NOW
      tag_code_name = CodeNameRefer.new(:TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name)
      @payroll_process.ins_term(period, tag_code_name, 3, amount_monthly:  3000)
      @payroll_process.ins_term(period, tag_code_name, 5, amount_monthly:  5000)
      @payroll_process.ins_term(period, tag_code_name, 4, amount_monthly:  4000)
      @payroll_process.ins_term(period, tag_code_name, 2, amount_monthly:  2000)
      pay_tag = @payroll_process.add_term(tag_code_name,  amount_monthly: 15000)
      pay_tag.code_order.should == 1
    end

    it "returns code_order == 3" do
      period = PayrollPeriod::NOW
      tag_code_name = CodeNameRefer.new(:TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name)
      @payroll_process.ins_term(period, tag_code_name, 5, amount_monthly:  5000)
      @payroll_process.ins_term(period, tag_code_name, 1, amount_monthly:  1000)
      @payroll_process.ins_term(period, tag_code_name, 4, amount_monthly:  4000)
      @payroll_process.ins_term(period, tag_code_name, 2, amount_monthly:  2000)
      pay_tag = @payroll_process.add_term(tag_code_name,  amount_monthly: 16000)
      pay_tag.code_order.should == 3
    end

    it "returns code_order == 6" do
      period = PayrollPeriod::NOW
      tag_code_name = CodeNameRefer.new(:TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name)
      @payroll_process.ins_term(period, tag_code_name, 3, amount_monthly:  3000)
      @payroll_process.ins_term(period, tag_code_name, 5, amount_monthly:  5000)
      @payroll_process.ins_term(period, tag_code_name, 1, amount_monthly:  1000)
      @payroll_process.ins_term(period, tag_code_name, 4, amount_monthly:  4000)
      @payroll_process.ins_term(period, tag_code_name, 2, amount_monthly:  2000)
      pay_tag = @payroll_process.add_term(tag_code_name,  amount_monthly: 16000)
      pay_tag.code_order.should == 6
    end
  end

  describe "payroll period" do
    it "returns payroll period january 2013" do
      @payroll_process.period.code.should == 201301
    end
  end

  describe "base salary" do
    it "returns monthly amount 15 000 CZK" do
      tag_code_name = CodeNameRefer.new(:TAG_SALARY_BASE, :TAG_SALARY_BASE.id2name)
      pay_tag = @payroll_process.add_term(tag_code_name, amount_monthly: 15000)
      pay_ter = @payroll_process.get_term(pay_tag)
      pay_ter[pay_tag].amount_monthly.should == 15000
    end
  end

  describe "working schedule" do
    it "returns weekly schedule hours 40" do
      tag_code_name = CodeNameRefer.new(:TAG_SCHEDULE_WORK, :TAG_SCHEDULE_WORK.id2name)
      pay_tag = @payroll_process.add_term(tag_code_name, hours_weekly: 40)
      pay_ter = @payroll_process.get_term(pay_tag)
      pay_ter[pay_tag].hours_weekly.should == 40
    end
  end

  describe "gross income" do
    it "returns gross income for base salary 15 000 CZK - 15 000 CZK"
  end

end

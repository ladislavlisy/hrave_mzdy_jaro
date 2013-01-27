require 'spec_helper'

describe "Payroll Tasks Calculation" do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    @payroll_process = PayrollProcess.new(period)
    #@payroll_process.ins_term_salary(PayTagGateway::TAG_SALARY_BASE, 3, 3000)
    #@payroll_process.ins_term_salary(PayTagGateway::TAG_SALARY_BASE, 5, 5000)
    #@payroll_process.ins_term_salary(PayTagGateway::TAG_SALARY_BASE, 1, 1000)
    #@payroll_process.ins_term_salary(PayTagGateway::TAG_SALARY_BASE, 4, 4000)
    #@payroll_process.ins_term_salary(PayTagGateway::TAG_SALARY_BASE, 2, 2000)
  end


  describe "payroll period" do
    it "returns payroll period january 2013" do
      @payroll_process.period.code.should == 201301
    end
  end

  describe "working schedule" do
    it "returns working schedule factor 1.00"
    it "returns weekly schedule hours 40"
  end

  describe "base salary" do
    it "returns monthly amount 15 000 CZK" do
      @payroll_process.add_term_salary(PayTagGateway::TAG_SALARY_BASE, 15000)
      @payroll_process.add_term_salary(PayTagGateway::TAG_SALARY_BASE, 16000)
    end
  end

  describe "gross income" do
    it "returns gross income for base salary 15 000 CZK - 15 000 CZK"
  end

end

require 'spec_helper'

describe 'Payroll Process Terms' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    pay_tags = PayTagGateway.new
    pay_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(pay_tags, pay_concepts, period)
  end

  describe 'working schedule' do
    it 'returns weekly schedule hours 40' do
      tag_code_name = ScheduleWorkTagRefer.new
      pay_tag = @payroll_process.add_term(tag_code_name, hours_weekly: 40)
      pay_ter = @payroll_process.get_term(pay_tag)
      pay_ter[pay_tag].hours_weekly.should == 40
    end
  end

  describe 'base salary' do
    it 'returns monthly amount 15 000 CZK' do
      tag_code_name = SalaryBaseTagRefer.new
      pay_tag = @payroll_process.add_term(tag_code_name, amount_monthly: 15000)
      pay_ter = @payroll_process.get_term(pay_tag)
      pay_ter[pay_tag].amount_monthly.should == 15000
    end
  end

end

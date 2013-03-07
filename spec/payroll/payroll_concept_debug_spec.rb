require 'spec_helper'

describe 'Payroll Process Calculations' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  describe 'Payroll Debug Test' do
    it 'returns Gross Income amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INCOME_GROSS, empty_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].amount.should == 15000
    end

    it 'returns Netto Income amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}
      relief_child_value = {relief_code: 2}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
      relief_child_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_child_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].amount.should == (13350+989)
    end
  end
end

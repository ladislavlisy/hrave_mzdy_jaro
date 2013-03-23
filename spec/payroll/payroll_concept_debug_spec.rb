require 'spec_helper'

describe 'Payroll Process Calculations' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  describe 'Payroll Debug Test' do
    it 'returns Netto Income amount' do
      empty_value = {}

      interest_value = {interest_code: 1, declare_code: 1}
      @payroll_process.add_term(PayTagGateway::REF_TAX_INCOME_BASE, interest_value)
      @payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH_BASE, interest_value)
      @payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH, interest_value)
      @payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL_BASE, interest_value)
      @payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL, interest_value)
      @payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH, interest_value)
      @payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL, interest_value)

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}
      relief_child_value = {relief_code: 1}

      @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
      @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_child_value)
      @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_child_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)

      result = @payroll_process.evaluate(result_tag)

      @payroll_names = PayNameGateway.new
      @payroll_names.load_models

      employer_name  = 'Hrave Mzdy - effortlessly, promptly, clearly Ltd.'
      employee_dept  = 'IT crowd'
      employee_name  = 'Ladislav Lisy'
      employee_numb  = '00012'

      payroll_period      = @payroll_process.period
      payroll_description = payroll_period.description

      @payroll_export = PayrollResultsExporter.new(employer_name, employee_dept,
                                                   employee_name, employee_numb,
                                                   @payroll_process)

      @res_schedule = @payroll_export.get_source_schedule_export
      @res_payments   = @payroll_export.get_source_payments_export
      @res_tax_income = @payroll_export.get_source_tax_income_export
      @res_ins_income = @payroll_export.get_source_ins_income_export
      @res_tax_source = @payroll_export.get_source_tax_source_export
      @res_tax_result = @payroll_export.get_source_tax_result_export
      @res_ins_result = @payroll_export.get_source_ins_result_export
      @res_summary    = @payroll_export.get_source_summary_export

      @res_column_left1  = @res_schedule + @res_payments
      @res_column_left2  = @res_tax_income + @res_ins_income
      @res_column_right1 = @res_tax_source.dup
      @res_column_right2 = @res_tax_result + @res_ins_result

      @res_column_left1.each_with_index do |payroll_result, index|
        payroll_result[:title].should_not be_nil
        payroll_result[:value].should_not be_nil
      end

      @res_schedule.count.should_not == 0
    end
  end
end

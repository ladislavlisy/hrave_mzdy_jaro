require 'spec_helper'
require 'builder'

describe 'Payroll Process Export Test' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  it 'Should create XML Payroll Export' do
    empty_value = {}

    interest_value = {interest_code: 1}
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

    @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
    @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
    @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
    @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
    @payroll_process.add_term(PayTagGateway::REF_INCOME_GROSS, empty_value)

    result_tag = @payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)

    result = @payroll_process.evaluate(result_tag)

    tag_employee_numb = '00012'
    tag_employee_dept = 'IT crowd'
    tag_employee_name = 'Ladislav Lisy'
    tag_employer_name = 'Hrave Mzdy - effortlessly, promptly, clearly Ltd.'

    payroll_export = PayrollResultsXmlExporter.new(tag_employer_name, tag_employee_dept,
                                                tag_employee_name, tag_employee_numb,
                                                @payroll_process)

    payroll_output = payroll_export.export_xml

    payroll_output.should_not == ''

  end
end



require 'spec_helper'

describe 'Payroll Process Calculations' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  describe 'Payroll Debug Test' do
    it 'returns Tax amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_ADVANCE, empty_value)

      result = @payroll_process.evaluate(result_tag)

      #Pojistné:	1 650 Kč
      #Základ daně:	20 100 Kč
      #Daň před slevami:	3 015 Kč
      #Sražená záloha na daň:	945 Kč
      #Daňová sleva:	2 070 Kč
      #Daňový bonus:	0 Kč
      #Čistý příjem:	12 405 Kč
      result[result_tag].payment.should == 3015
    end
  end
end

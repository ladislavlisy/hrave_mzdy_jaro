require 'spec_helper'

def get_result_income_base(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.income_base
  end
end

def get_result_payment(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.payment
  end
end

def get_result_after_reliefA(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.after_reliefA
  end
end

def get_result_after_reliefC(results, result_ref)
  result_select = results.select do |key, _|
    key.code == result_ref.code
  end
  result_value = result_select.inject (0)  do |agr, item|
    agr + item.last.after_reliefC
  end
end

describe 'Payroll Process Calculations' do

  before(:each) do
    period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  describe 'payroll period' do
    it 'returns payroll period month = 1 and year = 2013' do
      @payroll_process.period.month.should == 1
      @payroll_process.period.year.should == 2013
    end
  end

  describe 'working schedule' do
    it 'returns hours weekly schedule 40' do
      payroll_results = Hash.new
      schedule_value = {hours_weekly: 40}

      schedule_ref = PayTagGateway::REF_SCHEDULE_WORK
      schedule_tag = @payroll_process.add_term(schedule_ref, schedule_value)

      schedule_list = @payroll_process.get_term(schedule_tag)
      schedule_list[schedule_tag].hours_weekly.should == 40
    end

    it 'returns hours in week schedule 8,8,8,8,8,0,0' do
      schedule_value = {hours_weekly: 40}

      schedule_ref = PayTagGateway::REF_SCHEDULE_WORK
      schedule_tag = @payroll_process.add_term(schedule_ref, schedule_value)
      schedule_res = @payroll_process.evaluate(schedule_tag)

      schedule_res[schedule_tag].week_schedule.should == [8,8,8,8,8,0,0]
    end

    it 'returns hours in first seven days in month 8,8,8,8,0,0,8' do
      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      timesheet_value = {}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      result_tag = @payroll_process.add_term(PayTagGateway::REF_TIMESHEET_WORK, timesheet_value)

      timesheet_result = @payroll_process.evaluate(result_tag)
      #first week
      timesheet_result[result_tag].month_schedule[0].should == 8
      timesheet_result[result_tag].month_schedule[1].should == 8
      timesheet_result[result_tag].month_schedule[2].should == 8
      timesheet_result[result_tag].month_schedule[3].should == 8
      timesheet_result[result_tag].month_schedule[4].should == 0
      timesheet_result[result_tag].month_schedule[5].should == 0
      timesheet_result[result_tag].month_schedule[6].should == 8
    end
  end

  describe 'Schedule Term' do
    it 'returns Date from	Date end' do
      schedule_work_value = {hours_weekly: 40}
      timesheet_value = {}

      period = @payroll_process.period
      date_test_beg = Date.new(period.year, period.month, 15)
      date_test_end = Date.new(period.year, period.month, 24)
      schedule_term_value = {date_from: date_test_beg, date_end: date_test_end}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)

      schedule_term_res = @payroll_process.evaluate(schedule_term_tag)
      schedule_term_res[schedule_term_tag].day_ord_from.should == 15
      schedule_term_res[schedule_term_tag].day_ord_end.should == 24
    end
  end

  describe 'Timesheet Period' do
    it 'returns Array of working days' do
      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      timesheet_value = {}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      result_tag = @payroll_process.add_term(PayTagGateway::REF_TIMESHEET_PERIOD, timesheet_value)

      timesheet_result = @payroll_process.evaluate(result_tag)
      timesheet_result[result_tag].month_schedule[0].should == 8
    end

  end

  describe 'Timesheet Work' do
    it 'returns Array of working days' do
      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      timesheet_value = {}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      result_tag = @payroll_process.add_term(PayTagGateway::REF_TIMESHEET_WORK, timesheet_value)

      timesheet_result = @payroll_process.evaluate(result_tag)
      #first week
      timesheet_result[result_tag].month_schedule[0].should == 8
      timesheet_result[result_tag].month_schedule[1].should == 8
      timesheet_result[result_tag].month_schedule[2].should == 8
      timesheet_result[result_tag].month_schedule[3].should == 8
      timesheet_result[result_tag].month_schedule[4].should == 0
      timesheet_result[result_tag].month_schedule[5].should == 0
      timesheet_result[result_tag].month_schedule[6].should == 8
      timesheet_result[result_tag].month_schedule[7].should == 8
      #third week
      timesheet_result[result_tag].month_schedule[14].should == 8
      timesheet_result[result_tag].month_schedule[15].should == 8
      timesheet_result[result_tag].month_schedule[16].should == 8
      timesheet_result[result_tag].month_schedule[17].should == 8
      timesheet_result[result_tag].month_schedule[18].should == 0
      timesheet_result[result_tag].month_schedule[19].should == 0
      timesheet_result[result_tag].month_schedule[20].should == 8
      timesheet_result[result_tag].month_schedule[21].should == 8
    end

    it 'returns Array of working days form 10 to 25 of month' do
      schedule_work_value = {hours_weekly: 40}
      timesheet_value = {}

      period = @payroll_process.period
      date_test_beg = Date.new(period.year, period.month, 15)
      date_test_end = Date.new(period.year, period.month, 24)
      schedule_term_value = {date_from: date_test_beg, date_end: date_test_end}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      result_tag = @payroll_process.add_term(PayTagGateway::REF_TIMESHEET_WORK, timesheet_value)

      timesheet_result = @payroll_process.evaluate(result_tag)
      timesheet_result[result_tag].month_schedule[14-1].should == 0
      timesheet_result[result_tag].month_schedule[25-1].should == 0
      timesheet_result[result_tag].month_schedule[15-1].should == 8
      timesheet_result[result_tag].month_schedule[24-1].should == 8
    end
  end

  describe 'Hours Working' do
    it 'should return for period 1/2013 sum of working hours = 184' do
      schedule_work_value = {hours_weekly: 40}
      timesheet_value = {}

      period = @payroll_process.period
      schedule_term_value = {date_from: nil, date_end: nil}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      result_tag = @payroll_process.add_term(PayTagGateway::REF_HOURS_WORKING, timesheet_value)

      result_value = @payroll_process.evaluate(result_tag)
      result_value[result_tag].hours.should == 184
    end
  end

  describe 'Hours Absence' do
    it 'should return Sum of absence hours = 0' do
      schedule_work_value = {hours_weekly: 40}
      timesheet_value = {}

      period = @payroll_process.period
      schedule_term_value = {date_from: nil, date_end: nil}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      result_tag = @payroll_process.add_term(PayTagGateway::REF_HOURS_ABSENCE, timesheet_value)

      result_value = @payroll_process.evaluate(result_tag)
      result_value[result_tag].hours.should == 0
    end
  end

  describe 'Salary Base' do
    it 'should return for Salary amount	15 000,- Salary value = 15 000,-' do
      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)

      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      salary_result = @payroll_process.evaluate(salary_amount_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_SALARY_BASE)
      result_value.should == 15000
    end

    it 'should return for Salary amount	20 000,- Salary value = 15 000,-' do
      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      absence_hours_value = {hours: 46}
      salary_amount_value = {amount_monthly: 20000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      absence_hours_tag = @payroll_process.add_term(PayTagGateway::REF_HOURS_ABSENCE, absence_hours_value)

      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      salary_result = @payroll_process.evaluate(salary_amount_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_SALARY_BASE)
      result_value.should == 15000
    end
  end

  describe 'Insurance Health Base' do
    it 'returns Insurance base amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH_BASE, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_income_base(@payroll_process.get_results, PayTagGateway::REF_INSURANCE_HEALTH_BASE)
      result_value.should == 15000
    end
  end

  describe 'Insurance Social Base' do
    it 'returns Insurance base amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL_BASE, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_income_base(@payroll_process.get_results, PayTagGateway::REF_INSURANCE_SOCIAL_BASE)
      result_value.should == 15000
    end
  end

  describe 'Tax Income Base' do
    it 'returns Tax base amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_INCOME_BASE, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_income_base(@payroll_process.get_results, PayTagGateway::REF_TAX_INCOME_BASE)
      result_value.should == 15000
    end
  end

  describe 'Insurance health' do
    it 'returns Insurance amount ' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_INSURANCE_HEALTH)
      result_value.should == 675
    end
  end

  describe 'Insurance Social' do
    it 'returns Insurance amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_INSURANCE_SOCIAL)
      result_value.should == 975
    end
  end

  describe 'Tax Advanced' do
    #Insurance employee contribution:	1 650 Kč
    #Partial tax base:	20 100 Kč
    #Tax before relief:	3 015 Kč
    #Tax advance:	945 Kč
    #Tax relief:	2 070 Kč
    #Tax bonus:	0 Kč
    #Net income:	12 405 Kč

    it 'returns Employer Social Tax Base' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL)
      result_value.should == 3750
    end

    it 'returns Employer Health Tax Base' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_EMPLOYERS_HEALTH)
      result_value.should == 1350
    end

    it 'returns tax claim payer relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].tax_relief.should == 2070
    end

    it 'returns tax claim disability 1 relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_DISABILITY, relief_payers_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].tax_relief.should == 210
    end

    it 'returns tax claim disability 2 relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 2}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_DISABILITY, relief_payers_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].tax_relief.should == 420
    end

    it 'returns tax claim disability 3 relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 3}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_DISABILITY, relief_payers_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].tax_relief.should == 1345
    end

    it 'returns tax claim studying relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_STUDYING, relief_payers_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].tax_relief.should == 335
    end

    it 'returns tax claim child relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_payers_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].tax_relief.should == 967
    end

    it 'returns rounded base for tax advance' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_ADVANCE_BASE, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_income_base(@payroll_process.get_results, PayTagGateway::REF_TAX_ADVANCE_BASE)
      result_value.should == 20100
    end

    it 'returns Tax amount before relief' do
     empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_ADVANCE, empty_value)
      result = @payroll_process.evaluate(result_tag)

     result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_ADVANCE)
     result_value.should == 3015
    end

    it 'returns Tax amount after relief with payer relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_ADVANCE_FINAL, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_ADVANCE_FINAL)
      result_value.should == 945
    end

    it 'returns Tax amount after relief with child relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
      relief_child_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_ADVANCE_FINAL, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_after_reliefA(@payroll_process.get_results, PayTagGateway::REF_TAX_ADVANCE_FINAL)
      result_value.should == 945
    end

    it 'returns Tax amount after relief with child relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
      relief_child_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_ADVANCE_FINAL, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_ADVANCE_FINAL)
      result_value.should == 0
    end

    it 'returns Tax bonus after relief with child relief' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
      relief_child_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_BONUS_CHILD, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_BONUS_CHILD)
      result_value.should == 0
    end

    it 'returns Tax bonus after relief with child relief ZTP' do
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

      result_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_BONUS_CHILD, empty_value)
      result = @payroll_process.evaluate(result_tag)

      result_value = get_result_payment(@payroll_process.get_results, PayTagGateway::REF_TAX_BONUS_CHILD)
      result_value.should == 989
    end
  end

  describe 'Income Gross' do
    it 'returns Income amount' do
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
  end

  describe 'Income Netto' do
    it 'returns Income amount' do
      empty_value = {}

      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      salary_amount_value = {amount_monthly: 15000}
      relief_payers_value = {relief_code: 1}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      salary_amount_tag = @payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
      relief_payers_tag = @payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)

      result_tag = @payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)

      result = @payroll_process.evaluate(result_tag)

      result[result_tag].amount.should == 12405
    end

    it 'returns Netto Income amount with bonus' do
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

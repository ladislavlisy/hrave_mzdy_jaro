require 'spec_helper'

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

      schedule_ref = ScheduleWorkTagRefer.new
      schedule_tag = @payroll_process.add_term(schedule_ref, schedule_value)

      schedule_list = @payroll_process.get_term(schedule_tag)
      schedule_list[schedule_tag].hours_weekly.should == 40
    end

    it 'returns hours in week schedule 8,8,8,8,8,0,0' do
      schedule_value = {hours_weekly: 40}

      schedule_ref = ScheduleWorkTagRefer.new
      schedule_tag = @payroll_process.add_term(schedule_ref, schedule_value)
      schedule_res = @payroll_process.evaluate(schedule_tag)

      schedule_res[schedule_tag].week_schedule.should == [8,8,8,8,8,0,0]
    end

    it 'returns hours in first seven days in month 0,8,8,8,8,0,0' do
    end
  end

  describe 'Schedule Term' do
    it 'returns Date from	Date end' do
    end
  end

  describe 'Timesheet Period' do
    it 'returns Array of working days' do
      schedule_work_value = {hours_weekly: 40}
      schedule_term_value = {date_from: nil, date_end: nil}
      timesheet_value = {}

      schedule_work_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
      schedule_term_tag = @payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
      timesheet_tag = @payroll_process.add_term(PayTagGateway::REF_TIMESHEET_PERIOD, timesheet_value)

      timesheet_result = @payroll_process.evaluate(timesheet_tag)
      timesheet_result[timesheet_tag].month_schedule[0].should == 8
    end
  end

  describe 'Timesheet Work' do
    it 'returns Array of working days' do
    end
  end

  describe 'Hours Working' do
    it 'returns Sum of working hours' do
    end
  end

  describe 'Hours Absence' do
    it 'returns Sum of absence hours' do
    end
  end


  describe 'Salary Base' do
    it 'returns Salary amount	Salary value' do
    end
  end

  describe 'Insurance Health Base' do
    it 'returns Insurance base amount' do
    end
  end

  describe 'Insurance Social Base' do
    it 'returns Insurance base amount' do
    end
  end

  describe 'Tax Income Base' do
    it 'returns Tax base amount' do
    end
  end

  describe 'Insurance health' do
    it 'returns Insurance amount ' do
    end
  end

  describe 'Insurance Social' do
    it 'returns Insurance amount' do
    end
  end

  describe 'Tax Advanced' do
    it 'returns Tax amount' do
    end
  end

  describe 'Income Gross' do
    it 'returns Income amount' do
    end
  end

  describe 'Income Netto' do
    it 'returns Income amount' do
    end
  end

end

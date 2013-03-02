require 'spec_helper'

describe 'Payroll Concept Eval' do

  before(:each) do
    @payroll_period = FactoryGirl.build(:periodJan2013)
    @payroll_tags = PayTagGateway.new
    @payroll_concepts = PayConceptGateway.new
  end

  describe 'Schedule Weekly Concept' do
    it 'should return hours in week schedule 8,8,8,8,8,0,0' do
      payroll_results = Hash.new
      concept_value = {hours_weekly: 40}

      concept_item = @payroll_concepts.concept_for(:TAG_SCHEDULE_WORK, :CONCEPT_SCHEDULE_WEEKLY.id2name, concept_value)
      eval_value = concept_item.evaluate(@payroll_period, payroll_results)

      eval_value.week_schedule.should == [8,8,8,8,8,0,0]
    end
  end

  describe 'Calendar of period' do
    it 'should return 8 hours for working days of period' do
      payroll_results = Hash.new
      concept_value = {}
      weekly_hours = [8, 8, 8, 8, 8, 0, 0]

      concept_item = @payroll_concepts.concept_for(:TAG_TIMESHEET_PERIOD, :CONCEPT_TIMESHEET_PERIOD.id2name, concept_value)
      eval_value = concept_item.month_calendar_days(weekly_hours, @payroll_period)
      eval_value.count.should == 31
      #first week
      eval_value[0].should == 8
      eval_value[1].should == 8
      eval_value[2].should == 8
      eval_value[3].should == 8
      eval_value[4].should == 0
      eval_value[5].should == 0
      eval_value[6].should == 8
      eval_value[7].should == 8
      #third week
      eval_value[14].should == 8
      eval_value[15].should == 8
      eval_value[16].should == 8
      eval_value[17].should == 8
      eval_value[18].should == 0
      eval_value[19].should == 0
      eval_value[20].should == 8
      eval_value[21].should == 8
    end
  end

  describe 'Amount Monthly Concept' do
    it 'should return 15000 CZK for 15000 CZK monthly' do

    end
  end

  describe 'Insurance Health Base Concept' do
    it 'should return 15000 CZK for 15000 CZK salary' do

    end
  end

  describe 'Insurance Social Base Concept' do
    it 'should return 15000 CZK for 15000 CZK salary' do

    end
  end

  describe 'Income Taxable Concept' do
    it 'should return 15000 CZK for 15000 CZK salary' do

    end
  end

end


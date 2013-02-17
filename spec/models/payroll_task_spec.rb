require 'spec_helper'

describe PayrollTask do

  describe 'Factory' do

    it 'has a valid factory' do
      ptask_period = FactoryGirl.build(:periodJan2013)
      payroll_task = FactoryGirl.build(:task_example, :period_code => ptask_period.code)
      payroll_task.should be_valid
    end

    it 'is invalid without a description' do
      payroll_task = FactoryGirl.build(:task_empty)
      payroll_task.should_not be_valid
    end

    it 'returns a description as a string' do
      ptask_period = FactoryGirl.build(:periodJan2013)
      payroll_task = FactoryGirl.create(:task_example, :period_code => ptask_period.code)
      payroll_task.description.should == 'Payroll task (January 2013)'
    end

    it 'returns a payroll code as a integer' do
      ptask_period = FactoryGirl.build(:periodJan2013)
      payroll_task = FactoryGirl.create(:task_example, :period_code => ptask_period.code)
      payroll_task.period_code.should == 201301
    end

    it 'returns a period name as a string' do
      ptask_period = FactoryGirl.build(:periodJan2013)
      payroll_task = FactoryGirl.create(:task_example, :period_code => ptask_period.code)
      payroll_task.payroll_period.name.should == 'January 2013'
    end
  end

  describe 'Validation' do

    before(:each) do
      @attr_period = {
          :code => 201301,
          :name => 'January 2013'
      }
      @attr = {
          :payroll_period => PayrollPeriod.new(@attr_period),
          :description => 'Payroll period January 2013',
          :task_start => Time.now,
          :task_end => Time.now
      }
    end

    it 'should create a new instance given valid attributes' do
      PayrollTask.create(@attr)
    end

    it 'should require a description' do
      no_description_task = PayrollTask.new(@attr.merge(:description => ''))
      no_description_task.should_not be_valid
    end

    it 'should require a payroll_period' do
      no_period_task = PayrollTask.new(@attr.merge(:payroll_period => nil))
      no_period_task.should_not be_valid
    end

    it 'should require an period_code' do
      no_code_period = PayrollTask.new(@attr.merge(:period_code => nil))
      no_code_period.should_not be_valid
    end

    it 'should reject names that are too long' do
      long_name = 'a' * 251
      long_name_task = PayrollTask.new(@attr.merge(:description => long_name))
      long_name_task.should_not be_valid
    end

  end

end

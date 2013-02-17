require 'spec_helper'

describe PayrollPeriod do

  describe 'Factory' do
    it 'has a valid factory' do
      payroll_period = FactoryGirl.build(:periodJan2013)
      payroll_period.should be_valid
    end

    it 'is invalid without a name' do
      payroll_period = FactoryGirl.build(:periodNoName)
      payroll_period.should_not be_valid

    end

    it 'returns a code as a integer' do
      payroll_period = FactoryGirl.build(:periodJan2013)
      payroll_period.code.should == 201301
    end

    it 'returns a name as a string' do
      payroll_period = FactoryGirl.build(:periodJan2013)
      payroll_period.name.should == 'January 2013'
    end

  end

  describe 'Validation' do

    before(:each) do
      @attr = {
          :code => 201301,
          :name => 'January 2013'
      }
    end

    it 'should create a new instance given valid attributes' do
      PayrollPeriod.create(@attr)
    end

    it 'should require a name' do
      no_name_period = PayrollPeriod.new(@attr.merge(:name => ''))
      no_name_period.should_not be_valid
    end

    it 'should require an code' do
      no_code_period = PayrollPeriod.new(@attr.merge(:code => nil))
      no_code_period.should_not be_valid
    end

    it 'should reject names that are too long' do
      long_name = 'a' * 31
      long_name_period = PayrollPeriod.new(@attr.merge(:name => long_name))
      long_name_period.should_not be_valid
    end

  end

end

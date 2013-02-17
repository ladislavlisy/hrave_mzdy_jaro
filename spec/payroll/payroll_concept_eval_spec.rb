require 'spec_helper'

describe 'Payroll Concept Eval' do

  before(:each) do
    @payroll_period = FactoryGirl.build(:periodJan2013)
    @payroll_tags = PayTagGateway.new
    @payroll_concepts = PayConceptGateway.new
  end

  describe 'Schedule Weekly Concept' do
    it 'should return 184 hours for january 2013' do
      payroll_results = Hash.new
      concept_value = {}

      concept_item = @payroll_concepts.concept_for(:TAG_SCHEDULE_WORK, :CONCEPT_SCHEDULE_WEEKLY.id2name, concept_value)
      eval_value = concept_item.eval(@payroll_period, payroll_results)

      eval_value.should == 184
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


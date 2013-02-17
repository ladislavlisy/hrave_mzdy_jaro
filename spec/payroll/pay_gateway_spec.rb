require 'spec_helper'

describe 'Payroll Concept Gateway' do

  before(:each) do
    @payroll_gateway = PayConceptGateway.new
  end
  describe 'Salary CONCEPT_SALARY_MONTHLY' do

    it 'returns class name SalaryMonthlyConcept' do
      @payroll_gateway.classname_for(:CONCEPT_SALARY_MONTHLY.id2name).should == 'SalaryMonthlyConcept'
    end

    it 'returns code CONCEPT_SALARY_MONTHLY for new Concept' do
      concept_item = @payroll_gateway.concept_for(:TAG_SALARY_BASE, :CONCEPT_SALARY_MONTHLY.id2name, {amount_monthly: 0})
      concept_item.name.should == 'CONCEPT_SALARY_MONTHLY'
      concept_item.code.should == :CONCEPT_SALARY_MONTHLY
      concept_item.tag_code.should == :TAG_SALARY_BASE
    end

  end

end

describe 'Payroll Tag Gateway' do

  before(:each) do
    @payroll_gateway = PayTagGateway.new
  end
  describe 'Salary TAG_SALARY_BASE' do

    it 'returns class name SalaryBaseTag' do
      @payroll_gateway.classname_for(:TAG_SALARY_BASE.id2name).should == 'SalaryBaseTag'
    end

    it 'returns code TAG_SALARY_BASE for new Tag' do
      tag_item = @payroll_gateway.tag_for(:TAG_SALARY_BASE.id2name)
      tag_item.code.should == :TAG_SALARY_BASE
      tag_item.name.should == 'TAG_SALARY_BASE'
      tag_item.concept.code.should == :CONCEPT_SALARY_MONTHLY
    end

  end

end


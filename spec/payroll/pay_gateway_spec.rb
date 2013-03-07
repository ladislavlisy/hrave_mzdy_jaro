require 'spec_helper'

describe 'Payroll Concept Gateway' do

  before(:each) do
    @payroll_gateway = PayConceptGateway.new
    @concept_tags = SalaryBaseTag.new
  end

  describe 'Salary CONCEPT_SALARY_MONTHLY' do

    it 'returns class name SalaryMonthlyConcept' do
      @payroll_gateway.classname_for(@concept_tags.concept_name).should == 'SalaryMonthlyConcept'
    end

    it 'returns code CONCEPT_SALARY_MONTHLY for new Concept' do
      concept_item = @payroll_gateway.concept_for(@concept_tags.code, @concept_tags.concept_name, {amount_monthly: 0})
      concept_item.name.should == 'CONCEPT_SALARY_MONTHLY'
      concept_item.code.should == PayConceptGateway::CONCEPT_SALARY_MONTHLY
      concept_item.tag_code.should == PayTagGateway::TAG_SALARY_BASE
    end

  end

end

describe 'Payroll Tag Gateway' do

  before(:each) do
    @payroll_gateway = PayTagGateway.new
    @concept_tags = SalaryBaseTag.new
  end

  describe 'Salary TAG_SALARY_BASE' do

    it 'returns class name SalaryBaseTag' do
      @payroll_gateway.classname_for(@concept_tags.name).should == 'SalaryBaseTag'
    end

    it 'returns code TAG_SALARY_BASE for new Tag' do
      tag_item = @payroll_gateway.tag_for(@concept_tags.name)
      tag_item.code.should == PayTagGateway::TAG_SALARY_BASE
      tag_item.name.should == 'TAG_SALARY_BASE'
      tag_item.concept.code.should == PayConceptGateway::CONCEPT_SALARY_MONTHLY
    end

  end

end


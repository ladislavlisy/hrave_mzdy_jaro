require 'spec_helper'

describe "Payroll Concept Gateway" do

  before(:each) do
    @payroll_gateway = PayConceptGateway.new
  end
  describe "Salary CONCEPT_AMOUNT_MONTHLY" do

    it "returns class name AmountMonthlyConcept" do
      @payroll_gateway.classname_for(:CONCEPT_AMOUNT_MONTHLY.id2name).should == "AmountMonthlyConcept"
    end

    it "returns code CONCEPT_AMOUNT_MONTHLY for new Concept" do
      concept_item = @payroll_gateway.concept_for(:CONCEPT_AMOUNT_MONTHLY.id2name, {amount_monthly: 0})
      concept_item.code.should == :CONCEPT_AMOUNT_MONTHLY
      concept_item.name.should == "CONCEPT_AMOUNT_MONTHLY"
    end

  end

end

describe "Payroll Tag Gateway" do

  before(:each) do
    @payroll_gateway = PayTagGateway.new
  end
  describe "Salary TAG_SALARY_BASE" do

    it "returns class name SalaryBaseTag" do
      @payroll_gateway.classname_for(:TAG_SALARY_BASE.id2name).should == "SalaryBaseTag"
    end

    it "returns code TAG_SALARY_BASE for new Tag" do
      tag_item = @payroll_gateway.tag_for(:TAG_SALARY_BASE.id2name)
      tag_item.code.should == :TAG_SALARY_BASE
      tag_item.name.should == "TAG_SALARY_BASE"
      tag_item.concept.code.should == :CONCEPT_AMOUNT_MONTHLY
    end

  end

end


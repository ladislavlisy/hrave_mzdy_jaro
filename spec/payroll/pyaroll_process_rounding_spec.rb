require 'spec_helper'

describe 'Tax base rounding up' do

  before(:each) do
    @period = FactoryGirl.build(:periodJan2013)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    @payroll_process = PayrollProcess.new(payroll_tags, payroll_concepts, @period)
  end

  it 'Tax base under 100 CZK should be round up to 1 CZK' do
    test_concept = TaxAdvanceBaseConcept.new(PayTagGateway::REF_TAX_ADVANCE_BASE.code, amount: 0)
    tax_declared = 1
    test_concept.tax_rounded_base(@period, tax_declared, 99, 99).should ==  99
    test_concept.tax_rounded_base(@period, tax_declared, 99.01, 99.01).should == 100
    test_concept.tax_rounded_base(@period, tax_declared, 100, 100).should == 100
  end

  it 'Tax base over 100 CZK should be round up to 100 CZK' do
    test_concept = TaxAdvanceBaseConcept.new(PayTagGateway::REF_TAX_ADVANCE_BASE.code, amount: 0)
    tax_declared = 1
    test_concept.tax_rounded_base(@period, tax_declared, 100.01, 100.01).should == 200
    test_concept.tax_rounded_base(@period, tax_declared, 101, 101).should == 200
  end

  it 'Tax advance from negative base should be 0 CZK' do
    test_concept = TaxAdvanceConcept.new(PayTagGateway::REF_TAX_ADVANCE.code, amount: 0)
    test_concept.tax_adv_calculate(@period, -1, -1).should == 0
    test_concept.tax_adv_calculate(@period, 0, 0).should == 0
  end

  it 'Tax advance should be round up to 1 CZK' do
    test_concept = TaxAdvanceConcept.new(PayTagGateway::REF_TAX_ADVANCE.code, amount: 0)
    test_concept.tax_adv_calculate(@period, 3333, 3333).should == 500
    test_concept.tax_adv_calculate(@period, 2222, 2222).should == 334
  end

  it 'Health insurance should be round up to 1 CZK' do
    test_concept = InsuranceHealthConcept.new(PayTagGateway::REF_INSURANCE_HEALTH.code, amount: 0)
    test_concept.insurance_contribution(@period, 3333, 3333).should == 150
    test_concept.insurance_contribution(@period, 2222, 2222).should == 100
  end

  it 'Social insurance should be round up to 1 CZK' do
    test_concept = InsuranceSocialConcept.new(PayTagGateway::REF_INSURANCE_SOCIAL.code, amount: 0)
    test_concept.insurance_contribution(@period, 3333).should == 217
    test_concept.insurance_contribution(@period, 2222).should == 145
  end
end
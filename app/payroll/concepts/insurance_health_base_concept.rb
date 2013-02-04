class InsuranceHealthBaseConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INSURANCE_HEALTH_BASE, :CONCEPT_INSURANCE_HEALTH_BASE.id2name, tag_code)
  end

end
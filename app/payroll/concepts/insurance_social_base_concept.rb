class InsuranceSocialBaseConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INSURANCE_SOCIAL_BASE, :CONCEPT_INSURANCE_SOCIAL_BASE.id2name, tag_code)
  end

end
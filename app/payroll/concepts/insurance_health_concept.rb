class InsuranceHealthConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INSURANCE_HEALTH, :CONCEPT_INSURANCE_HEALTH.id2name, tag_code)
  end

  def pending_codes
    [ InsuranceHealthBaseTag.new ]
  end
end
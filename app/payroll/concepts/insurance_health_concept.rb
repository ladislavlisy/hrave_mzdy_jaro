class InsuranceHealthConcept < PayrollConcept
  def initialize
    super(:CONCEPT_INSURANCE_HEALTH, :CONCEPT_INSURANCE_HEALTH.id2name)
  end

  def pending_codes
    [ InsuranceHealthBaseTag.new ]
  end
end
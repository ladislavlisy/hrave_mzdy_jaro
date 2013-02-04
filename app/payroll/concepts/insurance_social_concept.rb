class InsuranceSocialConcept < PayrollConcept
  def initialize
    super(:CONCEPT_INSURANCE_SOCIAL, :CONCEPT_INSURANCE_SOCIAL.id2name)
  end

  def pending_codes
    [ InsuranceSocialBaseTag.new ]
  end

end
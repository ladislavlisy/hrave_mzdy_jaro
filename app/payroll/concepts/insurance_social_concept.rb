class InsuranceSocialConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INSURANCE_SOCIAL, :CONCEPT_INSURANCE_SOCIAL.id2name, tag_code)
  end

  def pending_codes
    [ InsuranceSocialBaseTag.new ]
  end

end
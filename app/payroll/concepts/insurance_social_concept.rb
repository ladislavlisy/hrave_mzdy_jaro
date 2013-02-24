class InsuranceSocialConcept < PayrollConcept
  def initialize(tag_code)
    super(InsuranceSocialConceptRefer.new, tag_code)
  end

  def pending_codes
    [ InsuranceSocialBaseTag.new ]
  end

end
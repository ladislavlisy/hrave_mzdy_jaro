class InsuranceSocialConcept < PayrollConcept
  def initialize(tag_code, values)
    super(InsuranceSocialConceptRefer.new, tag_code)
  end

  def pending_codes
    [ InsuranceSocialBaseTag.new ]
  end

end
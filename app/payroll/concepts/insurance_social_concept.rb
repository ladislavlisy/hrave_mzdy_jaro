class InsuranceSocialConcept < PayrollConcept
  def initialize(tag_code, values)
    super(InsuranceSocialConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

  def pending_codes
    [ InsuranceSocialBaseTag.new ]
  end

end
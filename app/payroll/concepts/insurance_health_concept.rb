class InsuranceHealthConcept < PayrollConcept
  def initialize(tag_code, values)
    super(InsuranceHealthConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

  def pending_codes
    [ InsuranceHealthBaseTag.new ]
  end
end
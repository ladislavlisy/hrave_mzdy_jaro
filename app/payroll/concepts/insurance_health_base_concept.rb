class InsuranceHealthBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(InsuranceHealthBaseConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

end
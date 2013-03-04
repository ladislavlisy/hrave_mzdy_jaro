class IncomeGrossConcept < PayrollConcept
  def initialize(tag_code, values)
    super(IncomeGrossConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

end
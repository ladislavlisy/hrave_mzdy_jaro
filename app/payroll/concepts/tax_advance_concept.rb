class TaxAdvanceConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TaxAdvanceConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

  def pending_codes
    [ TaxIncomeBaseTag.new ]
  end

end
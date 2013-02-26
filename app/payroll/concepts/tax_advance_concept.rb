class TaxAdvanceConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TaxAdvanceConceptRefer.new, tag_code)
  end

  def pending_codes
    [ TaxIncomeBaseTag.new ]
  end

end
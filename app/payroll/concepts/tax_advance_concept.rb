class TaxAdvanceConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_TAX_ADVANCE, :CONCEPT_TAX_ADVANCE.id2name, tag_code)
  end

  def pending_codes
    [ TaxIncomeBaseTag.new ]
  end

end
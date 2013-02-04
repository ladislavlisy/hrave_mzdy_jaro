class TaxAdvanceConcept < PayrollConcept
  def initialize
    super(:CONCEPT_TAX_ADVANCE, :CONCEPT_TAX_ADVANCE.id2name)
  end

  def pending_codes
    [ IncomeTaxableTag.new ]
  end

end
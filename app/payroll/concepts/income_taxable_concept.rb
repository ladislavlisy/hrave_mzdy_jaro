class IncomeTaxableConcept < PayrollConcept
  def initialize
    super(:CONCEPT_INCOME_TAXABLE, :CONCEPT_INCOME_TAXABLE.id2name)
  end

end
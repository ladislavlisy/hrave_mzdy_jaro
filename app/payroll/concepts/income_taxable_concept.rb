class IncomeTaxableConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INCOME_TAXABLE, :CONCEPT_INCOME_TAXABLE.id2name, tag_code)
  end

end
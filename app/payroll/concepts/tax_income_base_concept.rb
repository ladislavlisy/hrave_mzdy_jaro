class TaxIncomeBaseConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_TAX_INCOME_BASE, :CONCEPT_TAX_INCOME_BASE.id2name, tag_code)
  end

end
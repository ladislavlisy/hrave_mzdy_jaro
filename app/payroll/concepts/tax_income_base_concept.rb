class TaxIncomeBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TaxIncomeBaseConceptRefer.new, tag_code)
  end

end
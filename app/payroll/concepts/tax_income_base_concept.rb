class TaxIncomeBaseConcept < PayrollConcept
  def initialize(tag_code)
    super(TaxIncomeBaseConceptRefer.new, tag_code)
  end

end
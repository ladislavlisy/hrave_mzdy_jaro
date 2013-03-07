class TaxClaimChildResult < PayrollResult
  attr_reader :tax_relief

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @tax_relief = values[:tax_relief]
  end
end

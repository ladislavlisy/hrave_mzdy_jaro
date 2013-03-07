class TaxIncomeBaseResult < PayrollResult
  attr_reader :income_base

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @income_base = values[:income_base]
  end
end
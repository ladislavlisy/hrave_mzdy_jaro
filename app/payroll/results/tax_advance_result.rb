class TaxAdvanceResult < PayrollResult
  attr_reader :payment
  attr_reader :after_reliefA
  attr_reader :after_reliefC

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @payment       = values[:payment] || 0
    @after_reliefA = values[:after_reliefA] || 0
    @after_reliefC = values[:after_reliefC] || 0
  end

  def deduction
    @payment
  end
end
class TaxAfterReliefResult < PayrollResult
  attr_reader :payment

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @payment = values[:payment]
  end

  def deduction
    @payment
  end
end
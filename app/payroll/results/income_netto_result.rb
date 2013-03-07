class IncomeNettoResult < PayrollResult
  attr_reader :amount

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @amount = values[:amount]
  end
end
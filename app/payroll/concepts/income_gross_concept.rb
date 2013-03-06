class IncomeGrossConcept < PayrollConcept
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INCOME_GROSS, tag_code)
    init_values(values)
  end

  def init_values(values)
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def summary?
    true
  end
end
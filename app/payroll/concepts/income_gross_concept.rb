class IncomeGrossConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INCOME_GROSS, :CONCEPT_INCOME_GROSS.id2name, tag_code)
  end

end
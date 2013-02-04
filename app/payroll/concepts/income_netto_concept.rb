class IncomeNettoConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_INCOME_NETTO, :CONCEPT_INCOME_NETTO.id2name, tag_code)
  end

end
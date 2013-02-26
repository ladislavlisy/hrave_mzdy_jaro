class IncomeNettoConcept < PayrollConcept
  def initialize(tag_code, values)
    super(IncomeNettoConceptRefer.new, tag_code)
  end

end
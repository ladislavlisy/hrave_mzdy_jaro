class IncomeNettoConcept < PayrollConcept
  def initialize(tag_code)
    super(IncomeNettoConceptRefer.new, tag_code)
  end

end
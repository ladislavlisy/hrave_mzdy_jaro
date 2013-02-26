class IncomeGrossConcept < PayrollConcept
  def initialize(tag_code, values)
    super(IncomeGrossConceptRefer.new, tag_code)
  end

end
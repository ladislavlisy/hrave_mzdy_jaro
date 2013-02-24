class IncomeGrossConcept < PayrollConcept
  def initialize(tag_code)
    super(IncomeGrossConceptRefer.new, tag_code)
  end

end
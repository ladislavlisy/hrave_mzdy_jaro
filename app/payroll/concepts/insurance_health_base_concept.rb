class InsuranceHealthBaseConcept < PayrollConcept
  def initialize(tag_code)
    super(InsuranceHealthBaseConceptRefer.new, tag_code)
  end

end
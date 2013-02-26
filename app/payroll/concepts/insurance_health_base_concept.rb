class InsuranceHealthBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(InsuranceHealthBaseConceptRefer.new, tag_code)
  end

end
class InsuranceSocialBaseConcept < PayrollConcept
  def initialize(tag_code)
    super(InsuranceSocialBaseConceptRefer.new, tag_code)
  end

end
class InsuranceHealthConcept < PayrollConcept
  def initialize(tag_code, values)
    super(InsuranceHealthConceptRefer.new, tag_code)
  end

  def pending_codes
    [ InsuranceHealthBaseTag.new ]
  end
end
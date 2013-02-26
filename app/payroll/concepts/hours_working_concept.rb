class HoursWorkingConcept < PayrollConcept
  def initialize(tag_code, values)
    super(HoursWorkingConceptRefer.new, tag_code)
  end
end
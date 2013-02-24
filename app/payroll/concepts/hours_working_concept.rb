class HoursWorkingConcept < PayrollConcept
  def initialize(tag_code)
    super(HoursWorkingConceptRefer.new, tag_code)
  end
end
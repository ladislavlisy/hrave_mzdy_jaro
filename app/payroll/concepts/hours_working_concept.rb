class HoursWorkingConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_HOURS_WORKING, :CONCEPT_HOURS_WORKING.id2name, tag_code)
  end
end
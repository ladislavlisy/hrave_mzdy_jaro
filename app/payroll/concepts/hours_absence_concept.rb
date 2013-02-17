class HoursAbsenceConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_HOURS_ABSENCE, :CONCEPT_HOURS_ABSENCE.id2name, tag_code)
  end
end
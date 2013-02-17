class ScheduleTermConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_SCHEDULE_TERM, :CONCEPT_SCHEDULE_TERM.id2name, tag_code)
  end
end
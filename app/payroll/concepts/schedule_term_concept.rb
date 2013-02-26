class ScheduleTermConcept < PayrollConcept
  def initialize(tag_code, values)
    super(ScheduleTermConceptRefer.new, tag_code)
  end
end
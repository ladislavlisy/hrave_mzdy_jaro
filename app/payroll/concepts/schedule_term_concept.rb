class ScheduleTermConcept < PayrollConcept
  def initialize(tag_code)
    super(ScheduleTermConceptRefer.new, tag_code)
  end
end
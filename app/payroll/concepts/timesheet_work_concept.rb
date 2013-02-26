class TimesheetWorkConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TimesheetWorkConceptRefer.new, tag_code)
  end

  def pending_codes
    [ TimesheetPeriodTag.new, ScheduleTermTag.new ]
  end
end
class TimesheetWorkConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_TIMESHEET_WORK, :CONCEPT_TIMESHEET_WORK.id2name, tag_code)
  end

  def pending_codes
    [ TimesheetPeriodTag.new, ScheduleTermTag.new ]
  end
end
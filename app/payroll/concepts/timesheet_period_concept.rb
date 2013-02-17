class TimesheetPeriodConcept < PayrollConcept
  def initialize(tag_code)
    super(:CONCEPT_TIMESHEET_PERIOD, :CONCEPT_TIMESHEET_PERIOD.id2name, tag_code)
  end

  def pending_codes
    [ ScheduleWorkTag.new ]
  end
end
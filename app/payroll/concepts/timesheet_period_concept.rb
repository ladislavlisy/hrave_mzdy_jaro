class TimesheetPeriodConcept < PayrollConcept
  def initialize(tag_code)
    super(TimesheetPeriodConceptRefer.new, tag_code)
  end

  def pending_codes
    [ ScheduleWorkTag.new ]
  end
end
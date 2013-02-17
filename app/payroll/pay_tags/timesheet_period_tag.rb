class TimesheetPeriodTag < PayrollTag
  def initialize
    super(:TAG_TIMESHEET_PERIOD, :TAG_TIMESHEET_PERIOD.id2name,
          CodeNameRefer.new(:CONCEPT_TIMESHEET_PERIOD, :CONCEPT_TIMESHEET_PERIOD.id2name))
  end
end
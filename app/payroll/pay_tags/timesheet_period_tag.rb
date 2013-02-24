class TimesheetPeriodTag < PayrollTag
  def initialize
    super(TimesheetPeriodTagRefer.new,
          CodeNameRefer.new(:CONCEPT_TIMESHEET_PERIOD, :CONCEPT_TIMESHEET_PERIOD.id2name))
  end
end
class TimesheetPeriodTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TIMESHEET_PERIOD, PayConceptGateway::REFCON_TIMESHEET_PERIOD)
  end
end
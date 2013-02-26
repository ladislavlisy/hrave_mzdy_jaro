class TimesheetWorkTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TIMESHEET_WORK, PayConceptGateway::REFCON_TIMESHEET_WORK)
  end
end
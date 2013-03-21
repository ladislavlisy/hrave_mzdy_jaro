class TimesheetPeriodName < PayrollName
  def initialize
    super(PayTagGateway::REF_TIMESHEET_PERIOD,
          'Job Timesheet hours', 'Job Timesheet hours',
          PayNameGateway::VPAYGRP_SCHEDULE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
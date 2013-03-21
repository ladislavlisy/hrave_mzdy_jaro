class TimesheetWorkName < PayrollName
  def initialize
    super(PayTagGateway::REF_TIMESHEET_WORK,
          'Working Timesheet hours', 'Working Timesheet hours',
          PayNameGateway::VPAYGRP_SCHEDULE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
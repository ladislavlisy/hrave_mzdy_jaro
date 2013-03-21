class ScheduleWorkName < PayrollName
  def initialize
    super(PayTagGateway::REF_SCHEDULE_WORK,
          'Working schedule', 'Working schedule',
          PayNameGateway::VPAYGRP_SCHEDULE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
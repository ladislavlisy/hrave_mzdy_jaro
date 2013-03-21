class HoursAbsenceName < PayrollName
  def initialize
    super(PayTagGateway::REF_HOURS_ABSENCE,
          'Absence hours', 'Absence hours',
          PayNameGateway::VPAYGRP_SCHEDULE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
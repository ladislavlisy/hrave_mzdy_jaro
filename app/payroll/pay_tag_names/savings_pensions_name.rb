class SavingsPensionsName < PayrollName
  def initialize
    super(PayTagGateway::REF_SAVINGS_PENSIONS,
          'Pension savings', 'Pension savings contribution',
          PayNameGateway::VPAYGRP_INS_RESULT, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
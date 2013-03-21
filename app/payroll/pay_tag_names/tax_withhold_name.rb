class TaxWithholdName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_WITHHOLD,
          'Withholding Tax', 'Withholding Tax',
          PayNameGateway::VPAYGRP_TAX_RESULT, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
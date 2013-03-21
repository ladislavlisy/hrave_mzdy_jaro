class TaxWithholdBaseName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_WITHHOLD_BASE,
          'Withholding Tax base', 'Withholding Tax base',
          PayNameGateway::VPAYGRP_TAX_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
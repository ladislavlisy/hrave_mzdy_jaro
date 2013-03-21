class InsuranceHealthBaseName < PayrollName
  def initialize
    super(PayTagGateway::REF_INSURANCE_HEALTH_BASE,
          'Health insurance base', 'Assessment base for Health insurance',
          PayNameGateway::VPAYGRP_INS_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
class InsuranceSocialBaseName < PayrollName
  def initialize
    super(PayTagGateway::REF_INSURANCE_SOCIAL_BASE,
          'Social insurance base', 'Assessment base for Social insurance',
          PayNameGateway::VPAYGRP_INS_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
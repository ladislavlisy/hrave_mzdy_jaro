class InsuranceSocialName < PayrollName
  def initialize
    super(PayTagGateway::REF_INSURANCE_SOCIAL,
          'Social insurance', 'Social insurance contribution',
          PayNameGateway::VPAYGRP_INS_RESULT, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
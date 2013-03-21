class TaxClaimStudyingName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_STUDYING,
          'Tax benefit claim - studying', 'Tax benefit claim - studying',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
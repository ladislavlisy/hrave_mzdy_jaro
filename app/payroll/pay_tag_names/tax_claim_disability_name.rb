class TaxClaimDisabilityName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_DISABILITY,
          'Tax benefit claim - disability', 'Tax benefit claim - disability',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
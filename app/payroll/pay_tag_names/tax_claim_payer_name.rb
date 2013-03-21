class TaxClaimPayerName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_PAYER,
          'Tax benefit claim - payer', 'Tax benefit claim - payer',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
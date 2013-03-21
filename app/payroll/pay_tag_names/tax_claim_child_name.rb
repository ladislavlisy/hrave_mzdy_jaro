class TaxClaimChildName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_CHILD,
          'Tax benefit claim - child', 'Tax benefit claim - child',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
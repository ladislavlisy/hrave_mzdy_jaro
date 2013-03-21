class TaxAdvanceFinalName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_ADVANCE_FINAL,
          'Tax advance after relief', 'Tax advance after relief',
          PayNameGateway::VPAYGRP_TAX_RESULT, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
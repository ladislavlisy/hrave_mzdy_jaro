class TaxAdvanceBaseName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_ADVANCE_BASE,
          'Tax advance base', 'Tax advance base',
          PayNameGateway::VPAYGRP_TAX_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
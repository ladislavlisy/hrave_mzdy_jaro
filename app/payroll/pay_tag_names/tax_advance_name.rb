class TaxAdvanceName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_ADVANCE,
          'Tax advance', 'Tax advance',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
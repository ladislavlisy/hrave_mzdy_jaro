# encoding: utf-8

class TaxReliefPayerName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_RELIEF_PAYER,
          'Tax relief - payer', 'Tax relief - payer (§ 35ba)',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
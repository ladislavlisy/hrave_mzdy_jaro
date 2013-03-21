# encoding: utf-8

class TaxEmployersSocialName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL,
          "Tax employer’s Social insurance", "Tax employer’s Social insurance",
          PayNameGateway::VPAYGRP_TAX_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
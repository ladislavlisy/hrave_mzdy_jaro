# encoding: utf-8

class TaxEmployersHealthName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH,
          "Tax employer’s Health insurance", "Tax employer’s Health insurance",
          PayNameGateway::VPAYGRP_TAX_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
# encoding: utf-8

class TaxReliefChildName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_RELIEF_CHILD,
          'Tax relief - child', 'Tax relief - child (§ 35c)',
          PayNameGateway::VPAYGRP_TAX_SOURCE, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
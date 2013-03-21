class TaxBonusChildName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_BONUS_CHILD,
          'Tax bonus', 'Tax bonus',
          PayNameGateway::VPAYGRP_TAX_RESULT, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
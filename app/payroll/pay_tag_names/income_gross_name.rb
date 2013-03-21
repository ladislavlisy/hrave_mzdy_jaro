class IncomeGrossName < PayrollName
  def initialize
    super(PayTagGateway::REF_INCOME_GROSS,
          'Gross income', 'Gross income',
          PayNameGateway::VPAYGRP_SUMMARY, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
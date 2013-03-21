class TaxIncomeBaseName < PayrollName
  def initialize
    super(PayTagGateway::REF_TAX_INCOME_BASE,
          'Taxable income', 'Taxable income',
          PayNameGateway::VPAYGRP_TAX_INCOME, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
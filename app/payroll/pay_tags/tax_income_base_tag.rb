# Specification: Taxable Income

class TaxIncomeBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_INCOME_BASE, PayConceptGateway::REFCON_TAX_INCOME_BASE)
  end
end
# Specification: Tax Withhold

class TaxWithholdTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_WITHHOLD, PayConceptGateway::REFCON_TAX_WITHHOLD)
  end

  def deduction_netto?
    true
  end
end
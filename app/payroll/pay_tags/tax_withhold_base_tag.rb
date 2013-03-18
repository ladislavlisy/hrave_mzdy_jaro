class TaxWithholdBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_WITHHOLD_BASE, PayConceptGateway::REFCON_TAX_WITHHOLD_BASE)
  end
end
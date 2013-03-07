class TaxAdvanceBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_ADVANCE_BASE, PayConceptGateway::REFCON_TAX_ADVANCE_BASE)
  end
end
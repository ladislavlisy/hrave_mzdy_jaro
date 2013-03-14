class TaxAdvanceFinalTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_ADVANCE_FINAL, PayConceptGateway::REFCON_TAX_ADVANCE_FINAL)
  end

  def deduction_netto?
    true
  end
end
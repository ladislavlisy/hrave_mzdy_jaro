class TaxAfterReliefTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_AFTER_RELIEF, PayConceptGateway::REFCON_TAX_AFTER_RELIEF)
  end

  def deduction_netto?
    true
  end
end
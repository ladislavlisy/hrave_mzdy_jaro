class TaxReliefDisabilityTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_RELIEF_DISABILITY, PayConceptGateway::REFCON_TAX_RELIEF_DISABILITY)
  end
end
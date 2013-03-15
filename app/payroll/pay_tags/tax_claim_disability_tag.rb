class TaxClaimDisabilityTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_DISABILITY, PayConceptGateway::REFCON_TAX_CLAIM_DISABILITY)
  end
end
class TaxClaimPayerTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_PAYER, PayConceptGateway::REFCON_TAX_CLAIM_PAYER)
  end
end
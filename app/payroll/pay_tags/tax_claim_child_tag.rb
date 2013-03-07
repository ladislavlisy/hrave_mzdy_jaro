class TaxClaimChildTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_CHILD, PayConceptGateway::REFCON_TAX_CLAIM_CHILD)
  end
end
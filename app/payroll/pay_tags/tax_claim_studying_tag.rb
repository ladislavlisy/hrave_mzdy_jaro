class TaxClaimStudyingTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_CLAIM_STUDYING, PayConceptGateway::REFCON_TAX_CLAIM_STUDYING)
  end
end
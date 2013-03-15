class TaxReliefStudyingTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_RELIEF_STUDYING, PayConceptGateway::REFCON_TAX_RELIEF_STUDYING)
  end
end
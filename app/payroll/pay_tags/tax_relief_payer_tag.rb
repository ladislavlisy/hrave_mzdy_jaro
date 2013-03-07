class TaxReliefPayerTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_RELIEF_PAYER, PayConceptGateway::REFCON_TAX_RELIEF_PAYER)
  end
end
class TaxEmployersHealthTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH, PayConceptGateway::REFCON_TAX_EMPLOYERS_HEALTH)
  end
end
class TaxEmployersSocialTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL, PayConceptGateway::REFCON_TAX_EMPLOYERS_SOCIAL)
  end
end
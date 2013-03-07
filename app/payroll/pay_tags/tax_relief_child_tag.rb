class TaxReliefChildTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_RELIEF_CHILD, PayConceptGateway::REFCON_TAX_RELIEF_CHILD)
  end
end
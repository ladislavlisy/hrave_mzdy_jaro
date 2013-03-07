# Specification: Tax Advance

class TaxAdvanceTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_ADVANCE, PayConceptGateway::REFCON_TAX_ADVANCE)
  end
end
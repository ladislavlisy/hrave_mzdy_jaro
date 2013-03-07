class TaxBonusChildTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_TAX_BONUS_CHILD, PayConceptGateway::REFCON_TAX_BONUS_CHILD)
  end

  def income_netto?
    true
  end
end
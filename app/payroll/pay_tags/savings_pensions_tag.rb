class SavingsPensionsTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_SAVINGS_PENSIONS, PayConceptGateway::REFCON_SAVINGS_PENSIONS)
  end

  def deduction_netto?
    true
  end
end
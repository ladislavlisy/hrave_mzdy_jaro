# Specification: health insurance contribution

class InsuranceHealthTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_INSURANCE_HEALTH, PayConceptGateway::REFCON_INSURANCE_HEALTH)
  end

  def deduction_netto?
    true
  end
end
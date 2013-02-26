# Specification: Assessment base for health insurance

class InsuranceHealthBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_INSURANCE_HEALTH_BASE, PayConceptGateway::REFCON_INSURANCE_HEALTH_BASE)
  end
end
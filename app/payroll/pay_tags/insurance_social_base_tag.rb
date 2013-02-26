# Specification: Assessment base for social insurance

class InsuranceSocialBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_INSURANCE_SOCIAL_BASE, PayConceptGateway::REFCON_INSURANCE_SOCIAL_BASE)
  end
end
# Specification: social insurance contribution

class InsuranceSocialTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_INSURANCE_SOCIAL, PayConceptGateway::REFCON_INSURANCE_SOCIAL)
  end

end
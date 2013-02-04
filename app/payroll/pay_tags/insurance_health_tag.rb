# Specification: health insurance contribution

class InsuranceHealthTag < PayrollTag
  def initialize
    super(:TAG_INSURANCE_HEALTH, :TAG_INSURANCE_HEALTH.id2name,
          CodeNameRefer.new(:CONCEPT_INSURANCE_HEALTH, :CONCEPT_INSURANCE_HEALTH.id2name))

  end

end
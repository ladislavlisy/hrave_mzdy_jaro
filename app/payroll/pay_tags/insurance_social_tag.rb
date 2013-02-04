# Specification: social insurance contribution

class InsuranceSocialTag < PayrollTag
  def initialize
    super(:TAG_INSURANCE_SOCIAL, :TAG_INSURANCE_SOCIAL.id2name,
          CodeNameRefer.new(:CONCEPT_INSURANCE_SOCIAL, :CONCEPT_INSURANCE_SOCIAL.id2name))

  end

end
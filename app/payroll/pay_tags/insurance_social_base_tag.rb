# Specification: Assessment base for social insurance

class InsuranceSocialBaseTag < PayrollTag
  def initialize
    super(:TAG_INSURANCE_SOCIAL_BASE, :TAG_INSURANCE_SOCIAL_BASE.id2name,
          CodeNameRefer.new(:CONCEPT_INSURANCE_SOCIAL_BASE, :CONCEPT_INSURANCE_SOCIAL_BASE.id2name))
  end
end
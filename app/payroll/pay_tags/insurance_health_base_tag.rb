# Specification: Assessment base for health insurance

class InsuranceHealthBaseTag < PayrollTag
  def initialize
    super(InsuranceHealthBaseTagRefer.new,
          CodeNameRefer.new(:CONCEPT_INSURANCE_HEALTH_BASE, :CONCEPT_INSURANCE_HEALTH_BASE.id2name))

  end
end
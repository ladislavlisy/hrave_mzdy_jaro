# Specification: health insurance contribution

class InsuranceHealthTag < PayrollTag
  def initialize
    super(InsuranceHealthTagRefer.new,
          CodeNameRefer.new(:CONCEPT_INSURANCE_HEALTH, :CONCEPT_INSURANCE_HEALTH.id2name))

  end

end
# Specification: social insurance contribution

class InsuranceSocialTag < PayrollTag
  def initialize
    super(InsuranceSocialTagRefer.new,
          CodeNameRefer.new(:CONCEPT_INSURANCE_SOCIAL, :CONCEPT_INSURANCE_SOCIAL.id2name))

  end

end
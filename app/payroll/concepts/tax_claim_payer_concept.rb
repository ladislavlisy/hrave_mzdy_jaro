class TaxClaimPayerConcept < PayrollConcept
  attr_reader :relief_code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_CLAIM_PAYER, tag_code)
    init_values(values)
  end

  def init_values(values)
    @relief_code = values[:relief_code] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def evaluate(period, tag_config, results)
    relief_value = relief_claim_amount(period.year, relief_code)
    TaxClaimPayerResult.new(@tag_code, @code, self, {tax_relief: relief_value})
  end

  def relief_claim_amount(year, code)
    relief_amount = 0
    return relief_amount if code == 0
    if year >= 2012
      relief_amount = 2070
    elsif year == 2011
      relief_amount = 1970
    elsif year >= 2009
      relief_amount = 2070
    elsif year == 2008
      relief_amount = 2070
    elsif year >= 2006
      relief_amount = 600
    else
      relief_amount = 0
    end
    return relief_amount
  end
end

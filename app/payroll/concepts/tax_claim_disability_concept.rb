class TaxClaimDisabilityConcept < PayrollConcept
  attr_reader :relief_code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_CLAIM_DISABILITY, tag_code)
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
    TaxClaimResult.new(@tag_code, @code, self, {tax_relief: relief_value})
  end

  def relief_claim_amount(year, code)
    relief_amount = 0
    return relief_amount if code == 0
    case code
      when 1
        relief_amount = disability1_relief(year)
      when 2
        relief_amount = disability2_relief(year)
      when 3
        relief_amount = disability3_relief(year)
    end
    return relief_amount
  end

  def disability1_relief(year)
    if year >= 2009
      relief_amount = 210
    elsif year == 2008
      relief_amount = 210
    elsif year >= 2006
      relief_amount = 125
    else
      relief_amount = 0
    end
    relief_amount
  end

  def disability2_relief(year)
    if year >= 2009
      relief_amount = 420
    elsif year == 2008
      relief_amount = 420
    elsif year >= 2006
      relief_amount = 250
    else
      relief_amount = 0
    end
    relief_amount
  end

  def disability3_relief(year)
    if year >= 2009
      relief_amount = 1345
    elsif year == 2008
      relief_amount = 1345
    elsif year >= 2006
      relief_amount = 800
    else
      relief_amount = 0
    end
    relief_amount
  end
end

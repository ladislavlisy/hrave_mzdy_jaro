require_relative '../results/tax_claim_result'

class TaxClaimDisabilityConcept < PayrollConcept
  attr_reader :relief_code_1
  attr_reader :relief_code_2
  attr_reader :relief_code_3

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_CLAIM_DISABILITY, tag_code)
    init_values(values)
  end

  def init_values(values)
    @relief_code_1 = values[:relief_code_1] || 0
    @relief_code_2 = values[:relief_code_2] || 0
    @relief_code_3 = values[:relief_code_3] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def compute_result_value(year, code_1, code_2, code_3)
    relief_value_1 = relief1_claim_amount(year, code_1)
    relief_value_2 = relief2_claim_amount(year, code_2)
    relief_value_3 = relief3_claim_amount(year, code_3)

    relief_value_1 + relief_value_2 + relief_value_3
  end

  def evaluate(period, tag_config, results)
    relief_value = compute_result_value(period.year, relief_code_1, relief_code_2, relief_code_3)

    result_values = {tax_relief: relief_value}

    TaxClaimResult.new(@tag_code, @code, self, result_values)
  end

  def relief1_claim_amount(year, code)
    relief_amount = 0
    return relief_amount if code == 0
    relief_amount = disability1_relief(year)
  end

  def relief2_claim_amount(year, code)
    relief_amount = 0
    return relief_amount if code == 0
    relief_amount = disability2_relief(year)
  end

  def relief3_claim_amount(year, code)
    relief_amount = 0
    return relief_amount if code == 0
    relief_amount = disability3_relief(year)
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

  def export_xml(xml_builder)
    attributes = {}
    attributes[:relief_code_1] = @relief_code_1
    attributes[:relief_code_2] = @relief_code_2
    attributes[:relief_code_3] = @relief_code_3
    xml_builder.spec_value(attributes)
  end
end

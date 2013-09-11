require_relative '../results/tax_claim_result'

class TaxClaimChildConcept < PayrollConcept
  attr_reader :relief_code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_CLAIM_CHILD, tag_code)
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

  def compute_result_value(year, relief_code)
    relief_claim_amount(year, relief_code)
  end

  def evaluate(period, tag_config, results)
    relief_value = compute_result_value(period.year, relief_code)

    result_values = {tax_relief: relief_value}

    TaxClaimResult.new(@tag_code, @code, self, result_values)
  end

  def relief_claim_amount(year, code)
    relief_amount = 0
    return relief_amount if code == 0
    if year >= 2012
      relief_amount = 1117
    elsif year >= 2010
        relief_amount = 967
    elsif year == 2009
      relief_amount = 890
    elsif year == 2008
      relief_amount = 890
    elsif year >= 2006
      relief_amount = 500
    elsif year >= 2005
      relief_amount = 500
    else
      relief_amount = 0
    end
    if code == 2
      return 2*relief_amount
    end
    return relief_amount
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:relief_code] = @relief_code
    xml_builder.spec_value(attributes)
  end
end

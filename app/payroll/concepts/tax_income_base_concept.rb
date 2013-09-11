require_relative '../results/income_base_result'

class TaxIncomeBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_INCOME_BASE, tag_code)
    init_values(values)
  end

  def init_values(values)
    @interest_code = values[:interest_code] || 0
    @declare_code  = values[:declare_code] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_GROSS
  end

  def compute_result_value(tag_config, results)
    result_income = 0
    if !interest?
      result_income = 0
    else
      result_income = results.inject(0) do |agr, term_item|
        term_key    = term_item.first
        term_result = term_item.last
        agr + sum_term_for(tag_config, tag_code, term_key, term_result)
      end
    end
    result_income
  end

  def evaluate(period, tag_config, results)
    result_income = compute_result_value(tag_config, results)

    result_values = {
        income_base: result_income,
        interest_code: @interest_code,
        declare_code: @declare_code
    }

    IncomeBaseResult.new(@tag_code, @code, self, result_values)
  end

  def sum_term_for(tag_config, tag_code, result_key, result_item)
    tag_config_item = tag_config.find_tag(result_key.code)
    if result_item.summary_for?(tag_code)
      if tag_config_item.tax_advance?
        return result_item.payment
      end
    end
    return 0
  end

  def interest?
    @interest_code!=0
  end

  def declared?
    @declare_code!=0
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    attributes[:declare_code]  = @declare_code
    xml_builder.spec_value(attributes)
  end
end
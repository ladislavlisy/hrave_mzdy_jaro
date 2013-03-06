class TaxIncomeBaseConcept < PayrollConcept
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_INCOME_BASE, tag_code)
    init_values(values)
  end

  def init_values(values)
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def summary?
    true
  end

  def evaluate(period, tag_config, results)
    result_income = results.inject(0) do |agr, term_item|
      term_key    = term_item.first
      term_result = term_item.last
      agr + sum_term_for(tag_config, tag_code, term_key, term_result)
    end

    InsuranceHealthBaseResult.new(@tag_code, @code, self, {income_base: result_income})
  end

  def sum_term_for(tag_config, tag_code, result_key, result_item)
    tag_config_item = tag_config.tag_from_models(result_key)
    if result_item.summary_for?(tag_code)
      if tag_config_item.tax_advance?
        return result_item.payment
      end
    end
    return 0
  end
end
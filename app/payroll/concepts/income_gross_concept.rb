require_relative '../results/amount_result'

class IncomeGrossConcept < PayrollConcept
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INCOME_GROSS, tag_code)
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

  def calc_category
    PayrollConcept::CALC_CATEGORY_FINAL
  end

  def evaluate(period, tag_config, results)
    result_income = results.inject(0) do |agr, term_item|
      term_key    = term_item.first
      term_result = term_item.last
      agr + sum_term_for(tag_config, tag_code, term_key, term_result)
    end

    AmountResult.new(@tag_code, @code, self, {amount: result_income})
  end

  def sum_term_for(tag_config, tag_code, result_key, result_item)
    tag_config_item = tag_config.tag_from_models(result_key)
    if result_item.summary_for?(tag_code)
      if tag_config_item.income_gross?
        return result_item.payment
      end
    end
    return 0
  end
end
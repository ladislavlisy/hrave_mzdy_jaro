require_relative '../results/payment_deduction_result'

class TaxWithholdConcept < PayrollConcept
  TAG_WITHHOLD_BASE = PayTagGateway::REF_TAX_WITHHOLD_BASE.code
  TAG_INCOME_BASE = PayTagGateway::REF_TAX_INCOME_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_WITHHOLD, tag_code)
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

  def pending_codes
    [
      TaxWithholdBaseTag.new
    ]
  end

  def summary_codes
    [
      IncomeNettoTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    result_income = get_result_by(results, TAG_INCOME_BASE)
    result_advance = get_result_by(results, TAG_WITHHOLD_BASE)

    taxable_income = result_income.income_base
    taxable_partial = result_advance.income_base

    payment_value = tax_withhold_calculate(taxable_income, taxable_partial, period)

    PaymentDeductionResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def tax_withhold_calculate(tax_income, tax_base, period)
    if tax_base <= 0
      0
    else
      tax_withhold_calculate_month(tax_income, tax_base, period)
    end
  end

  def tax_withhold_calculate_month(tax_income, tax_base, period)
    if tax_base <= 0
      0
    else
      if period.year < 2008
        0
      elsif period.year < 2013
        fix_tax_round_up(
            big_multi(tax_base, tax_adv_bracket1(period.year))
        )
      else
        fix_tax_round_up(
            big_multi(tax_base, tax_adv_bracket1(period.year))
        )
      end
    end
  end

  def tax_adv_bracket1(year)
    factor = 0.0
    if year >= 2009
      factor = 15.0
    elsif year == 2008
      factor = 15.0
    elsif year >= 2006
      factor = 12.0
    else
      factor = 15.0
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end
end
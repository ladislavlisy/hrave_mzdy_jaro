class SavingsPensionsConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_INSURANCE_SOCIAL_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_SAVINGS_PENSIONS, tag_code)
    init_values(values)
  end

  def init_values(values)
    @interest_code = values[:interest_code] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def pending_codes
    [
      InsuranceSocialBaseTag.new
    ]
  end

  def summary_codes
    [
      IncomeNettoTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    result_income = get_result_by(results, TAG_AMOUNT_BASE)

    payment_value = insurance_contribution(period, result_income.income_base)
    PaymentDeductionResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def insurance_contribution(period, income_base)
    payment_value = fix_insurance_round_up(
        big_multi(income_base, pension_savings_factor(period, interest?()))
    )
  end

  def interest?
    @interest_code==1
  end

  def pension_savings_factor(period, pens_pill)
    factor = 0.0
    if (period.year<2013)
      factor = 0.0
    else
      if pens_pill
        factor = 3.0
      else
        factor = 0.0
      end
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end
end
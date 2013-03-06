class InsuranceHealthConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_INSURANCE_HEALTH_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INSURANCE_HEALTH, tag_code)
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
      InsuranceHealthBaseTag.new
    ]
  end

  def evaluate(period, tag_config, results)
    result_income = get_result_by(results, TAG_AMOUNT_BASE)

    big_income = BigDecimal.new(result_income.income_base, 15)
    empl_payment_value = big_insurance_round_up(
        BigDecimal.new(big_income*HealthInsuranceFactor(period))
    )
    cont_payment_value = fix_insurance_round_up(empl_payment_value.fdiv(3))
    InsuranceHealthResult.new(@tag_code, @code, self, {payment: cont_payment_value})
  end

  def HealthInsuranceFactor(period)
    factor = 0.0
    if (period.year<1993)
      factor = 0.0
    else (period.year<2009)
      factor = 13.5
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end
end
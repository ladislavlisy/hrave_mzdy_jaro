class TaxEmployersSocialConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_INSURANCE_SOCIAL_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_EMPLOYERS_SOCIAL, tag_code)
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

    payment_value = fix_insurance_round_up(
        big_multi(result_income.income_base, social_insurance_factor(period))
    )
    PaymentResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def social_insurance_factor(period)
    factor = 0.0
    if (period.year<2009)
      factor = 0
    else
      factor = 25
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end
end
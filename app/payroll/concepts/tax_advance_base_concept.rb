class TaxAdvanceBaseConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_TAX_INCOME_BASE.code
  TAG_SOCIAL_BASE = PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL.code
  TAG_HEALTH_BASE = PayTagGateway::REF_TAX_EMPLOYERS_HEALTH.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_ADVANCE_BASE, tag_code)
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
      TaxIncomeBaseTag.new,
      TaxEmployersSocialTag.new,
      TaxEmployersHealthTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    social_employer = get_result_by(results, TAG_SOCIAL_BASE)
    health_employer = get_result_by(results, TAG_HEALTH_BASE)
    result_income = get_result_by(results, TAG_AMOUNT_BASE)

    taxable_base = result_income.income_base
    taxable_social = social_employer.payment
    taxable_health = health_employer.payment

    taxable_super = taxable_base+taxable_social+taxable_health

    payment_value = tax_rounded_base(taxable_super, period)

    IncomeBaseResult.new(@tag_code, @code, self, {income_base: payment_value})
  end

  def tax_rounded_base(tax_base, period)
    year = period.year

    amount_for_calc = [0, tax_base].max
    if amount_for_calc > 100
      big_near_round_up(amount_for_calc, 100)
    else
      if year >= 2011
        big_tax_round_up(amount_for_calc)
      else
        big_tax_round_down(amount_for_calc)
      end
    end
  end
end
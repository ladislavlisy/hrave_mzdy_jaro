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

    is_tax_interest = result_income.interest?
    is_tax_declared = result_income.declared?
    if !is_tax_interest
      taxable_super = 0
    else
      taxable_base = result_income.income_base
      taxable_social = social_employer.payment
      taxable_health = health_employer.payment

      taxable_super = taxable_base+taxable_social+taxable_health
    end

    payment_value = tax_rounded_base(period, is_tax_declared, taxable_base, taxable_super)

    result_value = {income_base: payment_value}
    IncomeBaseResult.new(@tag_code, @code, self, result_value)
  end

  def tax_rounded_base(period, tax_decl, tax_income, tax_base)
    if tax_decl
      advance_rounded_base(period, tax_decl, tax_base)
    else
      if tax_income > tax_withhold_max(period.year)
        advance_rounded_base(period, tax_decl, tax_base)
      else
        0
      end
    end
  end

  def advance_rounded_base(period, tax_decl, tax_base)
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

  def tax_withhold_max(year)
    if year>=2004
      5000
    elsif year>=2001
      3000
    else
      2000
    end
  end
end
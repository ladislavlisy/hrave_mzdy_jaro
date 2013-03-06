class TaxAdvanceConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_TAX_INCOME_BASE.code
  TAG_SOCIAL_BASE = PayTagGateway::REF_INSURANCE_SOCIAL_BASE.code
  TAG_HEALTH_BASE = PayTagGateway::REF_INSURANCE_HEALTH_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_ADVANCE, tag_code)
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
      InsuranceSocialBaseTag.new,
      InsuranceHealthBaseTag.new
    ]
  end

  def evaluate(period, tag_config, results)
    part_social_income = get_result_by(results, TAG_SOCIAL_BASE)
    part_health_income = get_result_by(results, TAG_HEALTH_BASE)
    result_income = get_result_by(results, TAG_AMOUNT_BASE)

    big_taxable_base = BigDecimal.new(result_income.income_base, 15)
    big_social_base = BigDecimal.new(part_social_income.income_base, 15)
    part_social_value = fix_insurance_round_up(
        big_social_base*SocialSuperFactor(period)
    )
    big_health_base = BigDecimal.new(part_health_income.income_base, 15)
    empl_health_value = fix_insurance_round_up(
        big_health_base*HealthSuperFactor(period)
    )
    cont_health_value = fix_insurance_round_up(
        big_health_base*HealthSuperFactor(period).div(3)
    )
    part_health_value = empl_health_value - cont_health_value

    partial_tax_amount = big_taxable_base+part_social_income+part_health_income

    payment_value = tax_adv_calculate(result_income, partial_tax_amount, period)

    TaxAdvanceResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def tax_adv_calculate(tax_income, tax_base, period)
    partial_tax_amount = rounded_base(tax_base, period.year)

    if tax_base <= 100
      fix_tax_round_up(tax_base*tax_adv_bracket1(period.year))
    else
      tax_adv_calculate_month(tax_income, partial_tax_amount, period)
    end
  end

  def rounded_base(tax_base, year)
    amount_for_calc = [0, tax_base].max
    if amount_for_calc > 100
      near_round_up(amount_for_calc, 100)
    else
      if year >= 2011
        big_tax_round_up(amount_for_calc)
      else
        big_tax_round_down(amount_for_calc)
      end
    end
  end

  def tax_adv_calculate_month(tax_income, tax_base, period)
    if tax_base <= 0
      0
    else
      tax_base_down = near_round_down(tax_base)
      if period.year < 2008
        0
      elsif period.year < 2013
        big_tax_round_up(tax_base_down*tax_adv_bracket1(period.year))
      else
        tax_standard = big_tax_round_up(tax_base_down*tax_adv_bracket1(period.year))
        max_sol_base = tax_sol_bracket_max(period.year)
        eff_sol_base = BigDecimal.new([0,tax_income-max_sol_base].max, 15)
        tax_solidary = big_tax_round_up(eff_sol_base*tax_sol_bracket(period.year))
        tax_standard + tax_solidary
      end
    end
  end

  def tax_sol_bracket_max(year)
    if year >= 2013
      (4*25884)
    else
      0
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

  def tax_sol_bracket(year)
    factor = 0.0
    if year >= 2013
      factor = 7.0
    else
      factor = 0.0
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end

  def SocialSuperFactor(period)
    factor = 0.0
    if (period.year<2009)
      factor = 0
    else
      factor = 25
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end

  def HealthSuperFactor(period)
    factor = 0.0
    if (period.year<2009)
      factor = 0
    else
      factor = 13.5
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end
end
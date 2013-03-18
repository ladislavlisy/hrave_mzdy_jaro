class TaxAdvanceConcept < PayrollConcept
  TAG_ADVANCE_BASE = PayTagGateway::REF_TAX_ADVANCE_BASE.code
  TAG_INCOME_BASE = PayTagGateway::REF_TAX_INCOME_BASE.code

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
      TaxAdvanceBaseTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    result_income = get_result_by(results, TAG_INCOME_BASE)
    result_advance = get_result_by(results, TAG_ADVANCE_BASE)

    taxable_income = result_income.income_base
    taxable_partial = result_advance.income_base

    payment_value = tax_adv_calculate(taxable_income, taxable_partial, period)

    PaymentResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def tax_adv_calculate(tax_income, tax_base, period)
    if tax_base <= 0
      0
    elsif tax_base <= 100
      fix_tax_round_up(big_multi(tax_base, tax_adv_bracket1(period.year)))
    else
      tax_adv_calculate_month(tax_income, tax_base, period)
    end
  end

  def tax_adv_calculate_month(tax_income, tax_base, period)
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
        tax_standard = fix_tax_round_up(
            big_multi(tax_base, tax_adv_bracket1(period.year))
        )
        max_sol_base = tax_sol_bracket_max(period.year)
        eff_sol_base = [0,tax_income-max_sol_base].max
        tax_solidary = fix_tax_round_up(
            big_multi(eff_sol_base, tax_sol_bracket(period.year))
        )
        tax_standard + tax_solidary
      end
    end
  end

  def tax_wth_calculate_month(tax_income, tax_base, period)
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
end
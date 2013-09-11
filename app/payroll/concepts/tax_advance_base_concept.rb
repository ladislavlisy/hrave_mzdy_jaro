require_relative '../results/income_base_result'

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
      TaxEmployersHealthTag.new,
      TaxEmployersSocialTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def compute_result_value(period, is_tax_interest, is_tax_declared, taxable_health, taxable_social, taxable_base)
    if !is_tax_interest
      taxable_super = 0
    else
      taxable_super = taxable_base+taxable_health+taxable_social
    end

    tax_rounded_base(period, is_tax_declared, taxable_base, taxable_super)
  end

  def evaluate(period, tag_config, results)
    is_tax_interest = interest_result(results, TAG_AMOUNT_BASE)
    is_tax_declared = declared_result(results, TAG_AMOUNT_BASE)

    taxable_health = payment_result(results, TAG_HEALTH_BASE)
    taxable_social = payment_result(results, TAG_SOCIAL_BASE)
    taxable_base = income_base_result(results, TAG_AMOUNT_BASE)

    payment_value = compute_result_value(period, is_tax_interest, is_tax_declared,
                                         taxable_health, taxable_social, taxable_base)

    result_values = {income_base: payment_value}

    IncomeBaseResult.new(@tag_code, @code, self, result_values)
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
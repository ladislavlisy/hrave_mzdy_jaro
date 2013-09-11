require_relative '../results/payment_deduction_result'

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
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def compute_result_value(period, employee_base)
    payment_income = 0
    if !interest?
      payment_income = 0
    else
      payment_income = employee_base
    end

    insurance_contribution(period, payment_income)
  end

  def evaluate(period, tag_config, results)
    result_employee_base = employee_income_result(results, TAG_AMOUNT_BASE)

    payment_value = compute_result_value(period, result_employee_base)

    result_values = {payment: payment_value}

    PaymentDeductionResult.new(@tag_code, @code, self, result_values)
  end

  def insurance_contribution(period, income_base)
    payment_value = fix_insurance_round_up(
        big_multi(income_base, pension_savings_factor(period))
    )
  end

  def interest?
    @interest_code!=0
  end

  def pension_savings_factor(period)
    factor = 0.0
    if (period.year<2013)
      factor = 0.0
    else
      factor = 5.0
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    xml_builder.spec_value(attributes)
  end
end
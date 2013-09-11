require_relative '../results/payment_deduction_result'

class InsuranceSocialConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_INSURANCE_SOCIAL_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INSURANCE_SOCIAL, tag_code)
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
      payment_income = [0,employee_base].max
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
        big_multi(income_base, social_insurance_factor(period, false))
    )
  end

  def interest?
    @interest_code!=0
  end

  def social_insurance_factor(period, pens_pill)
    factor = 0.0
    if (period.year<1993)
      factor = 0.0
    elsif (period.year<2009)
      factor = 8.0
    elsif (period.year<2013)
      factor = 6.5
    else
      if pens_pill
        factor = 3.5
      else
        factor = 6.5
      end
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    xml_builder.spec_value(attributes)
  end
end
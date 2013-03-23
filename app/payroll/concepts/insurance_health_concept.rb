require_relative '../results/payment_deduction_result'

class InsuranceHealthConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_INSURANCE_HEALTH_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_INSURANCE_HEALTH, tag_code)
    init_values(values)
  end

  def init_values(values)
    @interest_code = values[:interest_code] || 0
    @minimum_asses = values[:minimum_asses] || 0
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

  def summary_codes
    [
      IncomeNettoTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_NETTO
  end

  def evaluate(period, tag_config, results)
    employer_income = 0
    employee_income = 0
    if !interest?
      employer_income = 0
      employee_income = 0
    else
      result_income = get_result_by(results, TAG_AMOUNT_BASE)
      employer_income = [0,result_income.employer_base].max
      employee_income = [0,result_income.employee_base].max
    end

    cont_payment_value = insurance_contribution(period, employer_income, employee_income)
    PaymentDeductionResult.new(@tag_code, @code, self, {payment: cont_payment_value})
  end

  def insurance_contribution(period, employer_income, employee_income)
    employer_base = [employer_income, employee_income].max
    employee_self = [0, employee_income - employer_income].max
    employee_base = [0, employer_base - employee_self].max

    health_factor = health_insurance_factor(period)

    suma_payment_value = fix_insurance_round_up(
        big_multi(employer_base, health_factor)
    )
    empl_payment_value = fix_insurance_round_up(
        big_multi(employee_self, health_factor) + big_div(big_multi(employee_base, health_factor), 3)
    )
    cont_payment_value = empl_payment_value
  end

  def interest?
    @interest_code!=0
  end

  def health_insurance_factor(period)
    factor = 0.0
    if (period.year<1993)
      factor = 0.0
    else (period.year<2009)
      factor = 13.5
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    attributes[:minimum_asses] = @minimum_asses
    xml_builder.spec_value(attributes)
  end
end
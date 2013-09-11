require_relative '../results/payment_result'

class TaxEmployersHealthConcept < PayrollConcept
  TAG_AMOUNT_BASE = PayTagGateway::REF_INSURANCE_HEALTH_BASE.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TAX_EMPLOYERS_HEALTH, tag_code)
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

  def compute_result_value(period, employer_base, employee_base)
    employer_income = 0
    employee_income = 0
    if !interest?
      employer_income = 0
      employee_income = 0
    else
      employer_income = [0,employer_base].max
      employee_income = [0,employee_base].max
    end

    insurance_payment(period, employer_income, employee_income)
  end

  def evaluate(period, tag_config, results)
    employer_base = employer_income_result(results, TAG_AMOUNT_BASE)
    employee_base = employee_income_result(results, TAG_AMOUNT_BASE)

    payment_value = compute_result_value(period, employer_base, employee_base)

    result_values = {payment: payment_value}

    PaymentResult.new(@tag_code, @code, self, result_values)
  end

  def insurance_payment(period, employer_income, employee_income)
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
    cont_payment_value = suma_payment_value - empl_payment_value
  end

  def interest?
    @interest_code!=0
  end

  def health_insurance_factor(period)
    factor = 0.0
    if (period.year < 2008)
      factor = 0.0
    elsif (period.year < 2009)
      factor = 13.5
    else
      factor = 13.5
    end
    return BigDecimal.new(factor.fdiv(100), 15)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:interest_code] = @interest_code
    xml_builder.spec_value(attributes)
  end
end
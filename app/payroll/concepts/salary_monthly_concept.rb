require_relative '../results/payment_result'

class SalaryMonthlyConcept < PayrollConcept
  attr_reader :amount_monthly

  TAG_TIMESHEET_PERIOD = PayTagGateway::REF_TIMESHEET_PERIOD.code
  TAG_HOURS_WORKING = PayTagGateway::REF_HOURS_WORKING.code
  TAG_HOURS_ABSENCE = PayTagGateway::REF_HOURS_ABSENCE.code

  def initialize(tag_code, values)
     super(PayConceptGateway::REFCON_SALARY_MONTHLY, tag_code)
     init_values(values)
  end

  def init_values(values)
    @amount_monthly = values[:amount_monthly]
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def pending_codes
    [
      HoursWorkingTag.new,
      HoursAbsenceTag.new
    ]
  end

  def summary_codes
    [
      IncomeGrossTag.new,
      IncomeNettoTag.new,
      InsuranceSocialBaseTag.new,
      InsuranceHealthBaseTag.new,
      TaxIncomeBaseTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_AMOUNT
  end

  def compute_result_value(timesheet_hours, working_hours, absence_hours)
    schedule_factor = big_decimal_cast(1.0)
    amount_factor = factorize_amount(amount_monthly, schedule_factor)

    payment_from_amount(amount_factor, timesheet_hours, working_hours, absence_hours)
  end

  def evaluate(period, tag_config, results)
    timesheet_hours = timesheet_hours_result(results, TAG_TIMESHEET_PERIOD)
    working_hours = term_hours_result(results, TAG_HOURS_WORKING)
    absence_hours = term_hours_result(results, TAG_HOURS_ABSENCE)

    payment_value = compute_result_value(timesheet_hours, working_hours, absence_hours)

    result_values = {payment: payment_value}

    PaymentResult.new(@tag_code, @code, self, result_values)
  end

  def factorize_amount(amount, schedule_factor)
    amount_factor = big_multi(amount, schedule_factor)
  end

  def payment_from_amount(big_amount, timesheet_hours, working_hours, absence_hours)
    salaried_hours = [0, working_hours-absence_hours].max
    payment_value = big_multi_and_div(salaried_hours, big_amount, timesheet_hours)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:amount_monthly] = @amount_monthly
    xml_builder.spec_value(xml_value, attributes)
  end

  def xml_value
    "#{amount_monthly} CZK"
  end

  def export_value_result
    format_amount = amount_monthly.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1 ")
    "#{format_amount} CZK"
  end
end
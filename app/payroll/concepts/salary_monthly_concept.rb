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
    CALC_CATEGORY_AMOUNT
  end

  def evaluate(period, tag_config, results)
    result_timesheet = get_result_by(results, TAG_TIMESHEET_PERIOD)
    result_working = get_result_by(results, TAG_HOURS_WORKING)
    result_absence = get_result_by(results, TAG_HOURS_ABSENCE)

    schedule_factor = schedule_factor(1.0)

    timesheet_hours = result_timesheet.hours
    working_hours = result_working.hours
    absence_hours = result_absence.hours

    amount_factor = factorize_amount(amount_monthly, schedule_factor)

    payment_value = payment_from_amount(amount_factor, timesheet_hours, working_hours, absence_hours)
    PaymentResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def schedule_factor(schedule_factor)
    BigDecimal.new(schedule_factor, 15)
  end

  def factorize_amount(amount, schedule_factor)
    amount_factor = big_multi(amount, schedule_factor)
  end

  def payment_from_amount(big_amount, timesheet_hours, working_hours, absence_hours)
    salaried_hours = [0, working_hours-absence_hours].max
    payment_value = big_multi_and_div(salaried_hours, big_amount, timesheet_hours)
  end
end
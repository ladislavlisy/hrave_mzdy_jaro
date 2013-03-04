class SalaryMonthlyConcept < PayrollConcept
  attr_reader :amount_monthly

  def initialize(tag_code, values)
     super(SalaryMonthlyConceptRefer.new, tag_code)
     @tag_pending_codes = rec_pending_codes(pending_codes())

     @amount_monthly = values[:amount_monthly]
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

  def evaluate(period, results)
    result_timesheet = get_result_by(results, :TAG_TIMESHEET_PERIOD)
    result_working = get_result_by(results, :TAG_HOURS_WORKING)
    result_absence = get_result_by(results, :TAG_HOURS_ABSENCE)

    schedule_factor = 1.0

    timesheet_hours = result_timesheet.hours
    working_hours = result_working.hours
    absence_hours = result_absence.hours

    amount_factor = factorize_amount(amount_monthly, schedule_factor)

    payment_value = payment_from_amount(amount_factor, timesheet_hours, working_hours, absence_hours)
    SalaryMonthlyResult.new(@tag_code, @code, self, {payment: payment_value})
  end

  def factorize_amount(amount, schedule_factor)
    amount_factor = amount*schedule_factor
  end

  def payment_from_amount(amount, timesheet_hours, working_hours, absence_hours)
    payment_value = ([0, working_hours-absence_hours].max).to_f/timesheet_hours.to_f*amount
  end
end
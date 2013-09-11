require_relative '../results/timesheet_result'

class TimesheetWorkConcept < PayrollConcept
  TAG_SCHEDULE_TERM = PayTagGateway::REF_SCHEDULE_TERM.code
  TAG_TIMESHEET_PERIOD = PayTagGateway::REF_TIMESHEET_PERIOD.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TIMESHEET_WORK, tag_code)
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
      TimesheetPeriodTag.new,
      ScheduleTermTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_TIMES
  end

  def compute_result_value(month_schedule_hours, day_ord_from, day_ord_end)
    timesheet_period = month_schedule_hours.to_enum.with_index(1).to_a

    hours_calendar = timesheet_period.map do |x, day|
      hours_from_calendar(day_ord_from, day_ord_end, day, x)
    end
    hours_calendar
  end

  def evaluate(period, tag_config, results)
    day_ord_from = day_from_result(results, TAG_SCHEDULE_TERM, PayrollConcept::TERM_BEG_FINISHED)

    day_ord_end = day_end_result(results, TAG_SCHEDULE_TERM, PayrollConcept::TERM_END_FINISHED)

    month_schedule = month_schedule_result(results, TAG_TIMESHEET_PERIOD)

    hours_calendar = compute_result_value(month_schedule, day_ord_from, day_ord_end)

    result_values = {month_schedule: hours_calendar}

    TimesheetResult.new(@tag_code, @code, self, result_values)
  end

  def hours_from_calendar(day_ord_from, day_ord_end, day_ordinal, work_hours)
    hours_in_day = work_hours
    hours_in_day = 0 if (day_ord_from > day_ordinal)
    hours_in_day = 0 if (day_ord_end < day_ordinal)
    return hours_in_day
  end
end
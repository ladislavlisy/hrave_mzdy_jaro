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
    CALC_CATEGORY_TIMES
  end

  def evaluate(period, tag_config, results)
    result_schedule_term = get_result_by(results, TAG_SCHEDULE_TERM)
    result_timesheet_period = get_result_by(results, TAG_TIMESHEET_PERIOD)
    day_ord_from = result_schedule_term.day_ord_from
    day_ord_end = result_schedule_term.day_ord_end

    timesheet_period = result_timesheet_period.month_schedule.to_enum.with_index(1).to_a

    hours_calendar = timesheet_period.map do |x, day|
      hours_from_calendar(day_ord_from, day_ord_end, day, x)
    end
    TimesheetResult.new(@tag_code, @code, self, {month_schedule: hours_calendar})
  end

  def hours_from_calendar(day_ord_from, day_ord_end, day_ordinal, work_hours)
    hours_in_day = work_hours
    hours_in_day = 0 if (day_ord_from > day_ordinal)
    hours_in_day = 0 if (day_ord_end < day_ordinal)
    return hours_in_day
  end
end
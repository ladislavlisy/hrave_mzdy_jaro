class TimesheetPeriodConcept < PayrollConcept
  TAG_SCHEDULE_WORK = PayTagGateway::REF_SCHEDULE_WORK.code

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_TIMESHEET_PERIOD, tag_code)
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
      ScheduleWorkTag.new
    ]
  end

  def calc_category
    CALC_CATEGORY_TIMES
  end

  def evaluate(period, tag_config, results)
    result_schedule_work = get_result_by(results, TAG_SCHEDULE_WORK)

    week_hours = result_schedule_work.week_schedule

    hours_calendar = month_calendar_days(week_hours, period)
    TimesheetResult.new(@tag_code, @code, self, {month_schedule: hours_calendar})
  end

  def month_calendar_days(week_hours, period)
    calendar_beg = Date.new(period.year, period.month, 1)
    calendar_beg_cwd = calendar_beg.cwday
    date_count = Time.days_in_month(period.month, period.year)
    hours_calendar = (1..date_count).each.map { |x| hours_from_week(week_hours, x, calendar_beg_cwd) }
  end

  def hours_from_week(week_hours, day_ordinal, calendar_beg_cwd)
    #calendar_day = Date.new(calendar_beg.year, calendar_beg.month, day_ordinal)
    day_of_week = (day_ordinal%7)+(calendar_beg_cwd-1)
    week_hours[day_of_week-1]
  end
end
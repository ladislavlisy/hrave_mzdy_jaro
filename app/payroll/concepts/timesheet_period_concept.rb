require_relative '../results/timesheet_result'

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
    PayrollConcept::CALC_CATEGORY_TIMES
  end

  def compute_result_value(period, week_schedule_hours)
    month_calendar_days(week_schedule_hours, period)
  end

  def evaluate(period, tag_config, results)
    week_hours = week_schedule_result(results, TAG_SCHEDULE_WORK)

    hours_calendar = compute_result_value(period, week_hours)

    result_values = {month_schedule: hours_calendar}

    TimesheetResult.new(@tag_code, @code, self, result_values)
  end

  def month_calendar_days(week_hours, period)
    calendar_beg = Date.new(period.year, period.month, 1)
    calendar_beg_cwd = calendar_beg.cwday
    date_count = Time.days_in_month(period.month, period.year)
    hours_calendar = (1..date_count).each.map { |x| hours_from_week(week_hours, x, calendar_beg_cwd) }
    hours_calendar
  end

  def hours_from_week(week_hours, day_ordinal, calendar_beg_cwd)
    #calendar_day = Date.new(calendar_beg.year, calendar_beg.month, day_ordinal)
    day_of_week = day_of_week_from_ordinal(day_ordinal, calendar_beg_cwd)
    work_hours = week_hours[day_of_week-1]
    work_hours
  end

  def day_of_week_from_ordinal(day_ordinal, calendar_beg_cwd)
    day_of_week = (((day_ordinal-1)+(calendar_beg_cwd-1))%7)+1
    day_of_week
  end
end
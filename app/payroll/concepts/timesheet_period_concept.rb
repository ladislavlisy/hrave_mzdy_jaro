class TimesheetPeriodConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TimesheetPeriodConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

  def pending_codes
    [ ScheduleWorkTag.new ]
  end

  def evaluate(period, results)
    result_schedule_work = get_result_by(results, :TAG_SCHEDULE_WORK)

    week_hours = result_schedule_work.week_schedule

    hours_calendar = month_calendar_days(week_hours, period)
    TimesheetPeriodResult.new(@tag_code, @code, self, {month_schedule: hours_calendar})
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
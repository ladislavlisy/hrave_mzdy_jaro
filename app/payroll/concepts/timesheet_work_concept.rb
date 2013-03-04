class TimesheetWorkConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TimesheetWorkConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())
  end

  def pending_codes
    [
      TimesheetPeriodTag.new,
      ScheduleTermTag.new
    ]
  end

  def evaluate(period, results)
    result_schedule_term = get_result_by(results, :TAG_SCHEDULE_TERM)
    result_timesheet_period = get_result_by(results, :TAG_TIMESHEET_PERIOD)
    day_ord_from = result_schedule_term.day_ord_from
    day_ord_end = result_schedule_term.day_ord_end

    timesheet_period = result_timesheet_period.month_schedule.to_enum.with_index(1).to_a

    hours_calendar = timesheet_period.map do |x, day|
      hours_from_calendar(day_ord_from, day_ord_end, day, x)
    end
    TimesheetWorkResult.new(@tag_code, @code, self, {month_schedule: hours_calendar})
  end

  def hours_from_calendar(day_ord_from, day_ord_end, day_ordinal, work_hours)
    hours_in_day = work_hours
    hours_in_day = 0 if (day_ord_from > day_ordinal)
    hours_in_day = 0 if (day_ord_end < day_ordinal)
    return hours_in_day
  end
end
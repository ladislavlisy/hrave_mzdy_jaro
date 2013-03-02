class TimesheetWorkConcept < PayrollConcept
  def initialize(tag_code, values)
    super(TimesheetWorkConceptRefer.new, tag_code)
  end

  def pending_codes
    [ TimesheetPeriodTag.new, ScheduleTermTag.new ]
  end

  def evaluate(period, results)
    result_schedule_term = get_result_by(results, :TAG_SCHEDULE_TERM)
    result_timesheet_work = get_result_by(results, :TAG_TIMESHEET_WORK)
    term_from = result_schedule_term.term_from
    term_end = result_schedule_term.term_end

    timesheet_work = result_timesheet_work.month_schedule.to_enum.with_index(1).to_a

    hours_calendar = timesheet_work.map do |x, day|
      hours_from_calendar(term_from, term_end, day, x)
    end
    TimesheetWorkResult.new(@tag_code, @code, self, {month_schedule: hours_calendar})
  end

  def hours_from_calendar(work_from, work_end, day_ordinal, work_hours)
    hours_in_day = work_hours
    hours_in_day = 0 if (work_from > day_ordinal)
    hours_in_day = 0 if (work_end < day_ordinal)
  end
end
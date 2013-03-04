class ScheduleWeeklyConcept < PayrollConcept
  attr_reader :hours_weekly

  def initialize(tag_code, values)
    super(ScheduleWeeklyConceptRefer.new, tag_code)
    @tag_pending_codes = rec_pending_codes(pending_codes())

    @hours_weekly = values[:hours_weekly]
  end

  def evaluate(period, results)
    hours_daily = @hours_weekly/5
    hours_week = [hours_daily,hours_daily,hours_daily,hours_daily,hours_daily,0,0]

    ScheduleWeeklyResult.new(@tag_code, @code, self, {week_schedule: hours_week})
  end
end
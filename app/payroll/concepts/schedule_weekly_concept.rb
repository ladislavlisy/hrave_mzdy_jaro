class ScheduleWeeklyConcept < PayrollConcept
  attr_reader :hours_weekly

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_SCHEDULE_WEEKLY, tag_code)
    init_values(values)
  end

  def init_values(values)
    @hours_weekly = values[:hours_weekly]
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def evaluate(period, tag_config, results)
    hours_daily = @hours_weekly/5
    hours_week = [hours_daily,hours_daily,hours_daily,hours_daily,hours_daily,0,0]

    ScheduleResult.new(@tag_code, @code, self, {week_schedule: hours_week})
  end
end
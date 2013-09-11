require_relative '../results/schedule_result'

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

  def compute_result_value(weekly_hours)
    hours_daily = hours_weekly_to_one_day(weekly_hours)
    hours_week = one_week_hours_from_daily_hours(hours_daily)
    hours_week
  end

  def evaluate(period, tag_config, results)
    hours_week = compute_result_value(@hours_weekly)

    result_values = {week_schedule: hours_week}

    ScheduleResult.new(@tag_code, @code, self, result_values)
  end

  def hours_weekly_to_one_day(weekly_hours)
    hours_daily = weekly_hours/5
  end

  def one_week_hours_from_daily_hours(hours_daily)
    hours_week = [hours_daily,hours_daily,hours_daily,hours_daily,hours_daily,0,0]
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:hours_weekly] = hours_weekly
    xml_builder.spec_value(xml_value, attributes)
  end

  def xml_value
    "#{hours_weekly} hours"
  end

  def export_value_result
    "#{hours_weekly} hours"
  end
end
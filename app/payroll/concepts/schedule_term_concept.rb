require_relative '../results/term_effect_result'

class ScheduleTermConcept < PayrollConcept
  attr_reader :date_from, :date_end

  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_SCHEDULE_TERM, tag_code)
    init_values(values)
  end

  def init_values(values)
    @date_from = values[:date_from]
    @date_end  = values[:date_end]
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def compute_result_value_from(period, date_from)
    day_term_from = PayrollConcept::TERM_BEG_FINISHED

    period_date_beg = Date.new(period.year, period.month, 1)
    day_term_from = date_from.day unless date_from.nil?
    day_term_from = period_date_beg.day if (date_from.nil? || date_from < period_date_beg)
    day_term_from
  end

  def compute_result_value_end(period, date_end)
    day_term_end  = PayrollConcept::TERM_END_FINISHED

    days_in_month = Time.days_in_month(period.month, period.year)

    period_date_end = Date.new(period.year, period.month, days_in_month)
    day_term_end  = date_end.day unless date_end.nil?
    day_term_end  = period_date_end.day if (date_end.nil? || date_end > period_date_end)
    day_term_end
  end

  def evaluate(period, tag_config, results)
    day_term_from = compute_result_value_from(period, @date_from)
    day_term_end  = compute_result_value_end(period, @date_end)

    result_values = {
        day_ord_from: day_term_from,
        day_ord_end: day_term_end
    }

    TermEffectResult.new(@tag_code, @code, self, result_values)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:date_from] = @date_from
    attributes[:date_end]  = @date_end
    xml_builder.spec_value(attributes)
  end
end
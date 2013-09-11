require_relative '../results/term_hours_result'

class HoursAbsenceConcept < PayrollConcept
  attr_reader :hours
  def initialize(tag_code, values)
    super(PayConceptGateway::REFCON_HOURS_ABSENCE, tag_code)
    init_values(values)
  end

  def init_values(values)
    @hours = values[:hours] || 0
  end

  def dup_with_value(code, values)
    new_concept = self.dup
    new_concept.init_code(code)
    new_concept.init_values(values)
    return new_concept
  end

  def pending_codes
    [
      TimesheetWorkTag.new
    ]
  end

  def calc_category
    PayrollConcept::CALC_CATEGORY_TIMES
  end

  def compute_result_value
    hours
  end

  def evaluate(period, tag_config, results)
    result_hours = compute_result_value

    result_values = {hours: result_hours}

    TermHoursResult.new(@tag_code, @code, self, result_values)
  end

  def export_xml(xml_builder)
    attributes = {}
    attributes[:hours] = @hours
    xml_builder.spec_value(xml_value, attributes)
  end

  def xml_value
    "#{hours} hours"
  end

  def export_value_result
    "#{hours} hours"
  end
end
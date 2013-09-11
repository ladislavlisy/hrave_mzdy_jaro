class TimesheetResult < PayrollResult
  attr_reader :month_schedule

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
    @month_schedule = values[:month_schedule]
  end

  def hours
    month_hours = 0
    if (!month_schedule.nil?)
      month_hours = month_schedule.inject(0) {|agr, dh| agr + dh}
    end
    return month_hours
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:month_schedule] = @month_schedule
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    sum_hours = month_schedule.inject (0) {|agr, item|  agr+item }
    "#{sum_hours} hours"
  end

  def export_value_result
    sum_hours = month_schedule.inject (0) {|agr, item|  agr+item }
    "#{sum_hours} hours"
  end
end
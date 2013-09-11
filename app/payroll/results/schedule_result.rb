class ScheduleResult < PayrollResult
  attr_reader :week_schedule

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
     @week_schedule = values[:week_schedule]
  end

  def hours
    sum_hours = week_schedule.inject (0) { |agr, item| agr+item }
    sum_hours
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:week_schedule] = @week_schedule
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    sum_hours = hours()
    "#{sum_hours} hours"
  end

  def export_value_result
    sum_hours = hours()
    "#{sum_hours} hours"
  end
end
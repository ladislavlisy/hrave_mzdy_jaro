class TermHoursResult < PayrollResult
  attr_reader :hours

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
    @hours = values[:hours]
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:hours] = @hours
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    "#{hours} hours"
  end

  def export_value_result
    "#{hours} hours"
  end
end
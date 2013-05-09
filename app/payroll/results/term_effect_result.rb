class TermEffectResult < PayrollResult
  attr_reader :day_ord_from, :day_ord_end

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
    @day_ord_from = values[:day_ord_from]
    @day_ord_end  = values[:day_ord_end]
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:day_ord_from] = @day_ord_from
    attributes[:day_ord_end]  = @day_ord_end
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    if (day_ord_from && day_ord_end)
      "#{day_ord_from} - #{day_ord_end}"
    else
      'whole period'
    end
  end

  def export_value_result
    if (day_ord_from && day_ord_end)
      "#{day_ord_from} - #{day_ord_end}"
    else
      'whole period'
    end
  end
end
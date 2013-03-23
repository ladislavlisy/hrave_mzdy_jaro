class TaxClaimResult < PayrollResult
  attr_reader :tax_relief

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @tax_relief = values[:tax_relief]
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:tax_relief] = @tax_relief
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    "#{tax_relief} CZK"
  end

  def export_value_result
    "#{tax_relief} CZK"
  end
end

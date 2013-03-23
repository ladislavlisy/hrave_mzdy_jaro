class AmountResult < PayrollResult
  attr_reader :amount

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @amount = values[:amount]
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:amount] = @amount
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    "#{amount} CZK"
  end

  def export_value_result
    "#{amount} CZK"
  end
end
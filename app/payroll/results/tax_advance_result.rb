class TaxAdvanceResult < PayrollResult
  attr_reader :payment
  attr_reader :after_reliefA
  attr_reader :after_reliefC

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
    @payment       = values[:payment] || 0
    @after_reliefA = values[:after_reliefA] || 0
    @after_reliefC = values[:after_reliefC] || 0
  end

  def deduction
    @payment
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:payment] = @payment
    attributes[:after_reliefA] = @after_reliefA
    attributes[:after_reliefC] = @after_reliefC
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    "#{payment} CZK"
  end

  def export_value_result
    format_amount = payment.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1 ")
    "#{format_amount} CZK"
  end
end
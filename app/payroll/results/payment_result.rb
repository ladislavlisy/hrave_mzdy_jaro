class PaymentResult < PayrollResult
  attr_reader :payment

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
    @payment = values[:payment]
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:payment] = @payment
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
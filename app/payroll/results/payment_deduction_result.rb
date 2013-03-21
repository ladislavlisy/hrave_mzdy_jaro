class PaymentDeductionResult < PayrollResult
  attr_reader :payment

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)

    @payment = values[:payment]
  end

  def deduction
    @payment
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:payment] = @payment
    xml_element.value(xml_value, attributes)
  end

  def xml_value
    "#{payment} CZK"
  end
end
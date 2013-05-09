class IncomeBaseResult < PayrollResult
  attr_reader :income_base
  attr_reader :employee_base
  attr_reader :employer_base

  def initialize(tag_code, concept_code, concept_item, values)
    super(tag_code, concept_code, concept_item)
    setup_values(values)
  end

  def setup_values(values)
    @income_base = values[:income_base] || 0
    @employee_base = values[:employee_base] || 0
    @employer_base = values[:employer_base] || 0
    @interest_code = values[:interest_code] || 0
    @minimum_asses = values[:minimum_asses] || 0
    @declare_code  = values[:declare_code] || 0
  end

  def interest?
    @interest_code!=0
  end

  def declared?
    @declare_code!=0
  end

  def minimum_assessment?
    @minimum_asses!=0
  end

  def export_xml_result(xml_element)
    attributes = {}
    attributes[:income_base]   = @income_base
    attributes[:employee_base] = @employee_base
    attributes[:employer_base] = @employer_base
    attributes[:declare_code]  = @declare_code
    attributes[:interest_code] = @interest_code
    attributes[:minimum_asses] = @minimum_asses

    xml_element.value(xml_value, attributes)
  end

  def xml_value
    "#{income_base} CZK"
  end

  def export_value_result
    format_amount = income_base.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1 ")
    "#{format_amount} CZK"
  end
end
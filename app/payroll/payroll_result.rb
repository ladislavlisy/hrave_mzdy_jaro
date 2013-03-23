class PayrollResult
  attr_reader :tag_code, :concept_code
  def initialize(code, concept_code, concept_item)
    @tag_code = code
    @concept_code = concept_code
    @concept = concept_item
  end

  def summary_for?(code)
    summary_codes = @concept.summary_codes.map {|x| x.code}
    summary_codes.include?(code)
  end

  def export_xml_tag_refer(tag_refer, xml_builder)
    attributes = {}
    attributes[:period_base] = tag_refer.period_base
    attributes[:code]        = tag_refer.code
    attributes[:code_order]  = tag_refer.code_order
    xml_builder.reference(attributes)
  end

  def export_xml_concept(xml_builder)
    @concept.export_xml(xml_builder)
  end

  def export_xml_result(xml_builder)
  end

  def export_value_result
  end

  def export_xml_names(tag_name, tag_item, tag_concept, xml_element)
    attributes = {}
    attributes[:tag_name] = tag_item.name
    attributes[:category] = tag_concept.name

    xml_element.item(attributes) do |xml_item|
      xml_item.title tag_name.title
      xml_item.description tag_name.description
      xml_item.group(tag_name.get_groups)
      export_xml_concept(xml_item)
      export_xml_result(xml_item)
    end
  end

  def export_xml(tag_refer, tag_name, tag_item, tag_concept, xml_element)
    export_xml_tag_refer(tag_refer, xml_element)
    export_xml_names(tag_name, tag_item, tag_concept, xml_element)
  end

  def export_title_value(tag_refer, tag_name, tag_item, tag_concept)
    return {title: tag_name.title, value: export_value_result}
  end
end
class PayrollName < CodeNameRefer
  attr_reader :title
  attr_reader :description

  def initialize(code_refer, title, description, v_group, h_group)
    super(code_refer.code, code_refer.name)
    @title = title
    @description = description
    @xml_groups = {}
    @xml_groups[:vgrp_pos] = v_group if v_group
    @xml_groups[:hgrp_pos] = h_group if h_group
  end

  def get_groups
    @xml_groups
  end

  def match_vgroup?(group_code)
    @xml_groups[:vgrp_pos] == group_code
  end

  def match_hgroup?(group_code)
    @xml_groups[:hgrp_pos] == group_code
  end
end
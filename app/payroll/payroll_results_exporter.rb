#require 'builder'

class PayrollResultsExporter
  attr_reader :employer_name
  attr_reader :employee_dept
  attr_reader :employee_name
  attr_reader :employee_numb
  attr_reader :payroll_names
  attr_reader :payroll_config
  attr_reader :payroll_period
  attr_reader :payroll_result

  def initialize(company, department, person, person_number, payroll)
    @payroll_names  = PayNameGateway.new

    @employer_name  = company
    @employee_dept  = department
    @employee_name  = person
    @employee_numb  = person_number

    @payroll_config = payroll
    @payroll_period = payroll.period
    @payroll_result = payroll.get_results
  end

  #VPAYGRP_SCHEDULE   = 'VPAYGRP_SCHEDULE'
  #VPAYGRP_PAYMENTS   = 'VPAYGRP_PAYMENTS'
  #VPAYGRP_TAX_SOURCE = 'VPAYGRP_TAX_SOURCE'
  #VPAYGRP_TAX_RESULT = 'VPAYGRP_TAX_RESULT'
  #VPAYGRP_INS_RESULT = 'VPAYGRP_INS_RESULT'
  #VPAYGRP_TAX_INCOME = 'VPAYGRP_TAX_INCOME'
  #VPAYGRP_INS_INCOME = 'VPAYGRP_INS_INCOME'
  #VPAYGRP_SUMMARY    = 'VPAYGRP_SUMMARY'

  def get_source_schedule_export
    get_result_export(PayNameGateway::VPAYGRP_SCHEDULE)
  end

  def get_source_payments_export
    get_result_export(PayNameGateway::VPAYGRP_PAYMENTS)
  end

  def get_source_tax_source_export
    get_result_export(PayNameGateway::VPAYGRP_TAX_SOURCE)
  end

  def get_source_tax_income_export
    get_result_export(PayNameGateway::VPAYGRP_TAX_INCOME)
  end

  def get_source_ins_income_export
    get_result_export(PayNameGateway::VPAYGRP_INS_INCOME)
  end

  def get_source_tax_result_export
    get_result_export(PayNameGateway::VPAYGRP_TAX_RESULT)
  end

  def get_source_ins_result_export
    get_result_export(PayNameGateway::VPAYGRP_INS_RESULT)
  end

  def get_source_summary_export
    get_result_export(PayNameGateway::VPAYGRP_SUMMARY)
  end

  def get_result_export(grp_position)
    payroll_result.inject ([]) do |agr, item|
      tag_result = item.first
      val_result = item.last
      agr.concat(item_export(grp_position,
                             payroll_config, payroll_names,
                             tag_result, val_result))
    end
  end

  def item_export(grp_position, pay_config, pay_names, tag_refer, val_result)
    tag_item    = pay_config.find_tag(val_result.tag_code)
    tag_concept = pay_config.find_concept(val_result.concept_code)
    tag_name    = pay_names.find_name(tag_refer.code)

    if tag_name.match_vgroup?(grp_position)
      [val_result.export_title_value(tag_refer, tag_name, tag_item, tag_concept)]
    else
      []
    end
  end
end
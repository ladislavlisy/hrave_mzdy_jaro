#require 'builder'

class PayrollResultsXmlExporter
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
    @payroll_names.load_models

    @employer_name  = company
    @employee_dept  = department
    @employee_name  = person
    @employee_numb  = person_number

    @payroll_config = payroll
    @payroll_period = payroll.period
    @payroll_result = payroll.get_results
  end

  def export_xml
    builder = Builder::XmlMarkup.new(indent: 2)
    builder.instruct! :xml, version: "1.0", encoding: "UTF-8"

    payroll_description = payroll_period.description

    builder.payslips do |xml_payslips|
      xml_payslips.payslip do |xml_payslip|

        xml_payslip.employee do |xml_employee|
          xml_employee.personnel_number employee_numb
          xml_employee.common_name      employee_name
          xml_employee.department       employee_dept
        end
        xml_payslip.employer do |xml_employer|
          xml_employer.common_name employer_name
        end
        xml_payslip.results do |xml_results|
          xml_results.period payroll_description

          payroll_result.each do |payroll_result|
            tag_result = payroll_result.first
            val_result = payroll_result.last
            xml_results.result do |xml_result|
              item_export_xml(payroll_config, payroll_names, tag_result, val_result, xml_result)
            end
          end
        end
      end
    end
    builder.target!
  end

  def item_export_xml(pay_config, pay_names, tag_refer, val_result, xml_element)
    tag_item    = pay_config.find_tag(val_result.tag_code)
    tag_concept = pay_config.find_concept(val_result.concept_code)
    tag_name    = pay_names.find_name(tag_refer.code)

    val_result.export_xml(tag_refer, tag_name, tag_item, tag_concept, xml_element)
  end
end
#require 'prawn'

class PayrollResultsPdfExporter < PayrollResultsExporter

  def initialize(company, department, person, person_number, payroll)
    super(company, department, person, person_number, payroll)
    @payslip_logo = 'payslip_the_game.png'
    @payslip_text = 'payslip_the_text.png'
  end

  def export_pdf
    period_desc = payroll_period.description

    res_schedule   = get_source_schedule_export
    res_payments   = get_source_payments_export
    res_tax_income = get_source_tax_income_export
    res_ins_income = get_source_ins_income_export
    res_tax_source = get_source_tax_source_export
    res_tax_result = get_source_tax_result_export
    res_ins_result = get_source_ins_result_export
    res_summary    = get_source_summary_export

    res_column_left1  = res_schedule + res_payments
    res_column_left2  = res_tax_income + res_ins_income
    res_column_right1 = res_tax_source.dup
    res_column_right2 = res_tax_result + res_ins_result

    doc = PaySlipDoc.new(@payslip_logo, @payslip_text, period_desc,
                         employer_name, employee_numb,
                         employee_dept, employee_name,
                         res_column_left1,  res_column_left2,
                         res_column_right1, res_column_right2,
                         res_summary)

    pdf_file_name = "output/payslip#{employee_numb}.pdf"
    doc.save_as pdf_file_name
    pdf_file_name
  end
end
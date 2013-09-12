#require 'Prawn'
#require 'payroll_concept'
#require 'payroll_result'
#require 'payroll_name'
#require 'pay_concept_gateway'
#require 'pay_name_gateway'
#require 'pay_tag_gateway'
#require 'payroll_process'

class PayrollTasksController < ApplicationController
  def new
    @title = "Start a new payroll task"
    @payroll_task = PayrollTask.new
    @payroll_task.period_code    = 201301
    @payroll_task.payroll_period = PayrollPeriod.find_by_code(@payroll_task.period_code)
    @payroll_task.description    = "Happy a new payroll!"
    @payroll_task.tax_payer   = 1
    @payroll_task.tax_declare = 1
    @payroll_task.tax_study   = 0
    @payroll_task.tax_disab1  = 0
    @payroll_task.tax_disab2  = 0
    @payroll_task.tax_disab3  = 0
    @payroll_task.tax_child1  = 0
    @payroll_task.tax_child2  = 0
    @payroll_task.tax_child3  = 0
    @payroll_task.tax_child4  = 0
    @payroll_task.tax_child5  = 0
    @payroll_task.ins_health  = 1
    @payroll_task.ins_social  = 1
    @payroll_task.min_health  = 1
  end

  def create
    @payroll_task  = PayrollTask.new

    payroll_data   = params[:payroll_task]
    period_code    = payroll_data[:payroll_period]
    description    = payroll_data[:description]
    payroll_period = PayrollPeriod.find_by_code(period_code.to_i)

    @payroll_task.period_code    = payroll_period.code if !payroll_period.nil?
    @payroll_task.payroll_period = payroll_period
    @payroll_task.description    = description
    @payroll_task.company_name   = payroll_data[:company_name]
    @payroll_task.payrolee_name  = payroll_data[:payrolee_name]
    @payroll_task.payrolee_mail  = payroll_data[:payrolee_mail]
    @payroll_task.employee_name  = payroll_data[:employee_name]
    @payroll_task.employer_name  = payroll_data[:employer_name]
    @payroll_task.employee_numb  = payroll_data[:employee_numb]
    @payroll_task.department     = payroll_data[:department]
    @payroll_task.empl_salary    = payroll_data[:empl_salary].to_i
    @payroll_task.tax_declare    = payroll_data[:tax_declare]
    @payroll_task.tax_payer      = payroll_data[:tax_payer]
    @payroll_task.tax_study      = payroll_data[:tax_study]
    @payroll_task.tax_disab1     = payroll_data[:tax_disab1]
    @payroll_task.tax_disab2     = payroll_data[:tax_disab2]
    @payroll_task.tax_disab3     = payroll_data[:tax_disab3]
    @payroll_task.tax_child1     = payroll_data[:tax_child1]
    @payroll_task.tax_child2     = payroll_data[:tax_child2]
    @payroll_task.tax_child3     = payroll_data[:tax_child3]
    @payroll_task.tax_child4     = payroll_data[:tax_child4]
    @payroll_task.tax_child5     = payroll_data[:tax_child5]
    @payroll_task.ins_health     = payroll_data[:ins_health]
    @payroll_task.ins_social     = payroll_data[:ins_social]
    @payroll_task.min_health     = payroll_data[:min_health]

    if @payroll_task.period_code.nil?
      @payroll_task.period_code  = 201301
    end
    if @payroll_task.empl_salary == 0
      @payroll_task.empl_salary  = 20000
    end

    if @payroll_task.description.nil? || @payroll_task.description.empty?
      @payroll_task.description   = 'Happy a new payroll!'
    end
    if @payroll_task.company_name.nil? || @payroll_task.company_name.empty?
      @payroll_task.company_name   = 'Sample company'
    end
    if @payroll_task.payrolee_name.nil? || @payroll_task.payrolee_name.empty?
    @payroll_task.payrolee_name  = 'Happy accountant'
    end
    if @payroll_task.payrolee_mail.nil? || @payroll_task.payrolee_mail.empty?
      @payroll_task.payrolee_mail  = 'hrave.mzdy@seznam.cz'
    end
    if @payroll_task.employee_name.nil? || @payroll_task.employee_name.empty?
      @payroll_task.employee_name  = 'Sample Employee'
    end
    if @payroll_task.employer_name.nil? || @payroll_task.employer_name.empty?
      @payroll_task.employer_name  = 'Sample Employer Ltd.'
    end
    if @payroll_task.employee_numb.nil? || @payroll_task.employee_numb.empty?
      @payroll_task.employee_numb  = '00001'
    end
    if @payroll_task.department.nil? || @payroll_task.department.empty?
      @payroll_task.department     = 'Sample Department'
    end

    if @payroll_task.save
      redirect_to @payroll_task
    else
      redirect_to :new_payroll_task
    end
  end

  def show
    @payroll_task = PayrollTask.find(params[:id])

    @payroll_names = PayNameGateway.new

    payroll_period  = @payroll_task.payroll_period
    @period_descr   = payroll_period.description

    @payroll_process = init_payroll_process(payroll_period)
    setup_payroll_process(@payroll_process, @payroll_task)

    @payroll_export = PayrollResultsExporter.new(@payroll_task.employer_name,
                                                 @payroll_task.department,
                                                 @payroll_task.employee_name,
                                                 @payroll_task.employee_numb,
                                                 @payroll_process)
    #@payroll_task.company_name
    #@payroll_task.payrolee_name
    #@payroll_task.payrolee_mail

    @res_schedule   = @payroll_export.get_source_schedule_export
    @res_payments   = @payroll_export.get_source_payments_export
    @res_tax_income = @payroll_export.get_source_tax_income_export
    @res_ins_income = @payroll_export.get_source_ins_income_export
    @res_tax_source = @payroll_export.get_source_tax_source_export
    @res_tax_result = @payroll_export.get_source_tax_result_export
    @res_ins_result = @payroll_export.get_source_ins_result_export
    @res_summary    = @payroll_export.get_source_summary_export

    @res_column_left1  = @res_schedule + @res_payments
    @res_column_left2  = @res_tax_income + @res_ins_income
    @res_column_right1 = @res_tax_source.dup
    @res_column_right2 = @res_tax_result + @res_ins_result
  end

  def download
    @payroll_task = PayrollTask.find(params[:id])

    @payroll_names = PayNameGateway.new

    payroll_period  = @payroll_task.payroll_period
    @period_descr   = payroll_period.description

    @payroll_process = init_payroll_process(payroll_period)
    setup_payroll_process(@payroll_process, @payroll_task)

    @payroll_export = PayrollResultsPdfExporter.new(@payroll_task.employer_name,
                                                    @payroll_task.department,
                                                    @payroll_task.employee_name,
                                                    @payroll_task.employee_numb,
                                                    @payroll_process)

    pdf_file_name = @payroll_export.export_pdf

    send_file pdf_file_name
  end

  def init_payroll_process(period)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  def setup_payroll_process(payroll_process, payroll_task)
    empty_value = {}

    payroll_process.add_term(PayTagGateway::REF_TAX_INCOME_BASE,
                             {interest_code: @payroll_task.tax_declare})
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH_BASE,
                             {interest_code: @payroll_task.ins_health,
                              minimum_asses: @payroll_task.min_health})
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH,
                             {interest_code: @payroll_task.ins_health})
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL_BASE,
                             {interest_code: @payroll_task.ins_social})
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL,
                             {interest_code: @payroll_task.ins_social})
    payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH,
                             {interest_code: @payroll_task.ins_health})
    payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL,
                             {interest_code: @payroll_task.ins_social})

    schedule_work_value = {hours_weekly: 40}
    schedule_term_value = {date_from: nil, date_end: nil}

    payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
    payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
    payroll_process.add_term(PayTagGateway::REF_SALARY_BASE,
                             {amount_monthly: @payroll_task.empl_salary})
    payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER,
                             {relief_code: @payroll_task.tax_payer})
    payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_STUDYING,
                             {relief_code: @payroll_task.tax_study})

    payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_DISABILITY,
                             {relief_code_1: @payroll_task.tax_disab1,
                              relief_code_2: @payroll_task.tax_disab2,
                              relief_code_3: @payroll_task.tax_disab3})

    if (@payroll_task.tax_child1 == 1)
      payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD,
                               {relief_code: @payroll_task.tax_payer})
    end
    if (@payroll_task.tax_child2 == 1)
      payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD,
                               {relief_code: @payroll_task.tax_payer})
    end
    if (@payroll_task.tax_child3 == 1)
      payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD,
                               {relief_code: @payroll_task.tax_payer})
    end
    if (@payroll_task.tax_child4 == 1)
      payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD,
                               {relief_code: @payroll_task.tax_payer})
    end
    if (@payroll_task.tax_child5 == 1)
      payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_CHILD,
                               {relief_code: @payroll_task.tax_payer})
    end

    payroll_process.add_term(PayTagGateway::REF_INCOME_GROSS, empty_value)

    result_tag = payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)

    payroll_process.evaluate(result_tag)
  end
end

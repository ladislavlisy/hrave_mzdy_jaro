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

    if @payroll_task.save
      redirect_to @payroll_task
    else
      redirect_to :new_payroll_task
    end
  end

  def show
    @payroll_task = PayrollTask.find(params[:id])

    @payroll_names = PayNameGateway.new
    @payroll_names.load_models

    @employer_name  = 'Hrave Mzdy - effortlessly, promptly, clearly Ltd.'
    @employee_dept  = 'IT crowd'
    @employee_name  = 'Ladislav Lisy'
    @employee_numb  = '00012'

    payroll_period  = @payroll_task.payroll_period
    @period_descr   = payroll_period.description

    @payroll_process = init_payroll_process(payroll_period)
    setup_payroll_process(@payroll_process)

    @payroll_export = PayrollResultsExporter.new(@employer_name,
                                                 @employee_dept,
                                                 @employee_name,
                                                 @employee_numb,
                                                 @payroll_process)

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

  def init_payroll_process(period)
    payroll_tags = PayTagGateway.new
    payroll_concepts = PayConceptGateway.new
    PayrollProcess.new(payroll_tags, payroll_concepts, period)
  end

  def setup_payroll_process(payroll_process)
    empty_value = {}

    interest_value = {interest_code: 1}
    payroll_process.add_term(PayTagGateway::REF_TAX_INCOME_BASE, interest_value)
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH_BASE, interest_value)
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_HEALTH, interest_value)
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL_BASE, interest_value)
    payroll_process.add_term(PayTagGateway::REF_INSURANCE_SOCIAL, interest_value)
    payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_HEALTH, interest_value)
    payroll_process.add_term(PayTagGateway::REF_TAX_EMPLOYERS_SOCIAL, interest_value)

    schedule_work_value = {hours_weekly: 40}
    schedule_term_value = {date_from: nil, date_end: nil}
    salary_amount_value = {amount_monthly: 15000}
    relief_payers_value = {relief_code: 1}

    payroll_process.add_term(PayTagGateway::REF_SCHEDULE_WORK, schedule_work_value)
    payroll_process.add_term(PayTagGateway::REF_SCHEDULE_TERM, schedule_term_value)
    payroll_process.add_term(PayTagGateway::REF_SALARY_BASE, salary_amount_value)
    payroll_process.add_term(PayTagGateway::REF_TAX_CLAIM_PAYER, relief_payers_value)
    payroll_process.add_term(PayTagGateway::REF_INCOME_GROSS, empty_value)

    result_tag = payroll_process.add_term(PayTagGateway::REF_INCOME_NETTO, empty_value)

    payroll_process.evaluate(result_tag)
  end
end

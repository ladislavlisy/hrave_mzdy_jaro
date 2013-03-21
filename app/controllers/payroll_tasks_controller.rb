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

    #@payroll_process set_data
    #@payroll_process calculate
    #render @payroll_process
  end
end

class PayrollTasksController < ApplicationController
  def new
    @title = "Start a new payroll task"
    @payroll_task = PayrollTask.new

  end
end

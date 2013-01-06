class CreatePayrollTasks < ActiveRecord::Migration
  def change
    create_table :payroll_tasks do |t|
      t.integer :period_code, :references => [:payroll_periods, :code]
      t.string :description
      t.datetime :task_start
      t.datetime :task_end

      t.timestamps
    end
  end
end

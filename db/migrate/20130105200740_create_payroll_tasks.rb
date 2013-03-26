class CreatePayrollTasks < ActiveRecord::Migration
  def change
    create_table :payroll_tasks do |t|
      t.integer :period_code, :references => [:payroll_periods, :code]
      t.string :description
      t.datetime :task_start
      t.datetime :task_end
      t.string :company_name
      t.string :payrolee_name
      t.string :payrolee_mail
      t.string :employee_name
      t.string :employer_name
      t.string :employee_numb
      t.string :department

      t.integer :empl_salary
      t.boolean :tax_declare
      t.boolean :tax_payer
      t.boolean :tax_study
      t.boolean :tax_disab1
      t.boolean :tax_disab2
      t.boolean :tax_disab3
      t.boolean :tax_child1
      t.boolean :tax_child2
      t.boolean :tax_child3
      t.boolean :tax_child4
      t.boolean :tax_child5
      t.boolean :ins_health
      t.boolean :ins_social
      t.boolean :min_health

      t.timestamps
    end
  end
end

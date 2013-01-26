class CreatePayrollPeriods < ActiveRecord::Migration
  def change
    create_table :payroll_periods, {:id => false, :primary_key => 'code'} do |t|
      t.integer :code
      t.string :name

      t.timestamps
    end
  end
end

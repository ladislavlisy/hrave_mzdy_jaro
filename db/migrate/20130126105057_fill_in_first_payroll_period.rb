class FillInFirstPayrollPeriod < ActiveRecord::Migration
  def up
    PayrollPeriod.create(:code => 201201, :name => "January 2012")
    PayrollPeriod.create(:code => 201301, :name => "January 2013")
  end

  def down
    PayrollPeriod.where("code = 201301 or code = 201201").each do |period_item|
      period_item.destroy
    end
  end
end

class PayrollTask < ActiveRecord::Base
  has_one :payroll_period, :primary_key => :period_code, :foreign_key => :code
  validates :payroll_period, :presence => true
  validates :period_code, :presence => true
  validates :description, :presence => true,
            :length     => { :maximum => 250 }
  attr_accessible :payroll_period, :period_code, :description, :task_end, :task_start
end

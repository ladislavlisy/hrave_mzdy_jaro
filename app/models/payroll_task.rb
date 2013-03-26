class PayrollTask < ActiveRecord::Base
  has_one :payroll_period, :primary_key => :period_code, :foreign_key => :code
  validates :payroll_period, :presence => true
  validates :period_code,
            :numericality => { :greater_than => 200001 }
  validates :description, :presence => true,
            :length     => { :maximum => 250 }
  attr_accessible :payroll_period, :period_code, :description, :task_end, :task_start
  attr_accessible :company_name, :payrolee_name, :payrolee_mail
  attr_accessible :employee_name, :employer_name, :employee_numb, :department
  attr_accessible :empl_salary, :tax_declare, :tax_payer, :tax_study
  attr_accessible :tax_disab1, :tax_disab2, :tax_disab3
  attr_accessible :tax_child1, :tax_child2, :tax_child3, :tax_child4, :tax_child5
  attr_accessible :ins_health, :ins_social, :min_health

end

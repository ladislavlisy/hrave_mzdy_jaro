class SalaryBaseName < PayrollName
  def initialize
    super(PayTagGateway::REF_SALARY_BASE,
          'Base Salary', 'Base Salary',
          PayNameGateway::VPAYGRP_PAYMENTS, PayNameGateway::HPAYGRP_UNKNOWN)
  end
end
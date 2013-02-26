class SalaryBaseTag < PayrollTag
  def initialize
    super(PayTagGateway::REF_SALARY_BASE, PayConceptGateway::REFCON_SALARY_MONTHLY)
  end
end